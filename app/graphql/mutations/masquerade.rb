module Mutations
  class Masquerade < Mutations::BaseMutation
    type Types::Objects::ApiKey, null: false

    argument :email, String, required: true

    def resolve(email:)
      if Current.user.allowed_to_masquerade?
        user = User.find_by(email: email)
        user.masquerade
        # Todo - add method in user which tracks masquerading action 
      else
        # Current user is not allowed to masquerade
      end
    end
  end
end