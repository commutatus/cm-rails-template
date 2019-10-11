Mutations::AuthMutationQueryType = GraphQL::InterfaceType.define do
  name "AuthMutationQuery"

  field :signUp,                          Types::Objects::ApiKeyType do
    is_public true
    description "Sign up a new user"
    argument :auth,                       Types::Inputs::AuthInput
    resolve ->(_, args, _) {
      user = User.find_by(email: args[:auth][:email])
      if user 
        return GraphQL::ExecutionError.new("This email address already exists. Please log in to continue.")
      else
        user = User.new args[:auth].to_h
        user.save!
        WelcomeEmailJob.perform_later(user) unless Rails.env.development?
        return user.live_api_key
      end
    }
  end

  field :login,                           Types::Objects::ApiKeyType do
    is_public true
    description "Existing user signs in with email"
    argument :auth,                       Types::Inputs::AuthInput
    resolve ->(_, args, _){
      user = User.find_by(email: args[:auth][:email])
      if user
        if user.valid_password?(args[:auth][:password])
          user.find_or_generate_api_key
          user.live_api_key
        else
          return GraphQL::ExecutionError.new("incorrect password") 
        end
      else
        return GraphQL::ExecutionError.new("incorrect email") 
      end
    } 
  end

  field :changePassword,                  types.Boolean do 
    description "A user changes their password"
    argument :current_password,           !types.String
    argument :new_password,               !types.String
    resolve ->(_, args, _){
      user = Current.user
      if user.valid_password?(args[:current_password])
        user.password = args[:new_password]
        user.save!
        user.saved_change_to_encrypted_password?
      else
        return GraphQL::ExecutionError.new("Incorrect current password") 
      end
    }
  end

  field :generateResetPasswordToken,      types.String do 
    is_public true
    description "An existing user requests a password reset"
    argument :email,                      !types.String
    argument :redirect_url,               !types.String
    resolve ->(_, args, _){
      user = User.find_by(email: args[:email])
      if user.email_verified?
        user.generate_reset_password_token
        ResetEmailTokenJob.perform_later(user, args[:redirect_url])
        return user.email
      else
        return GraphQL::ExecutionError.new("Email address must be verified to allow password reset.") 
      end
    }
  end

  field :resetPassword,                   Types::Objects::ApiKeyType do 
    is_public true
    description "An existing user can reset their password with the correct token"
    argument :reset_password_token,       !types.String
    argument :password,                   !types.String
    resolve ->(_, args, _){
      user = User.find_by(reset_password_token: args[:reset_password_token])
      if user
        user.reset_password_with_token(args[:password])
        return user.find_or_generate_api_key
      else
        return GraphQL::ExecutionError.new("Invalid password reset token") 
      end
    }
  end                 

end
