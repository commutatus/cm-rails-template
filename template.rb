# template.rb
require 'byebug'

def source_paths
  Array(super) +
    [File.join(File.expand_path(File.dirname(__FILE__)),'')]
end

install_pg = yes?("Do you want to install postgresql? (y/n)")
gem 'pg' if install_pg
install_devise = yes?("Do you want to install devise? (y/n)")
gem 'devise' if install_devise
install_slim = yes?("Do you want to install Slim? (y/n)")
gem 'slim-rails' if install_slim
install_simple_form = yes?("Do you want to install Simple form? (y/n)")
gem 'simple_form' if install_simple_form
install_graphql = yes?("Do you want to install Graphql? (y/n)")
gem 'graphql', github: 'commutatus/graphql-ruby' if install_graphql
gem 'graphql-errors' if install_graphql
gem 'graphql-rails_logger' if install_graphql
install_rubocop = yes?("Do you want to install Rubocop? (y/n)")
gem 'rubocop' if install_rubocop
install_local_time = yes?("Do you want to install Local time? (y/n)")
gem 'local_time' if install_local_time
install_overcommit = yes?("Do you want to install Overcommit? (y/n)")
gem 'overcommit' if install_overcommit
install_paranoia = yes?("Do you want to install Paranoia? (y/n)")
gem 'paranoia' if install_paranoia
install_rack_cors = yes?("Do you want to install rack-cors? (y/n)")
gem 'rack-cors' if install_rack_cors
install_spotlight_search = yes?("Do you want to install Spotlight? (y/n)")
gem 'spotlight_search' if install_spotlight_search
install_rails_best_practices = yes?("Do you want to install Rails best practice? (y/n)")
gem 'rails_best_practices' if install_rails_best_practices
install_omniauth = yes?("Do you want to install omniauth (y/n)")
gem 'omniauth' if install_omniauth
install_facebook = yes?("Do you want to install facebook (y/n)")
gem 'omniauth-facebook' if install_facebook
install_google = yes?("Do you want to install google (y/n)")
gem 'omniauth-google-oauth2'
install_whenever = yes?("Do you want to install whenever (y/n)")
gem 'whenever' if install_whenever
install_better_error = yes?("Do you want to install better error (y/n)")
install_binding_of_caller = yes?("Do you want to install binding of caller (y/n)")
gem_group :development do
  gem 'graphiql-rails' if install_graphql
  gem 'better_errors' if install_better_error
  gem "binding_of_caller" if install_binding_of_caller
end if install_better_error || install_binding_of_caller
install_rollbar = yes?("Do you want to install rollbar (y/n)")
gem 'rollbar' if install_rollbar
install_scout = yes?("Do you want to install scout (y/n)")
gem 'scout_apm' if install_scout
install_sidekiq = yes?("Do you want to install sidekiq (y/n)")
gem 'sidekiq' if install_sidekiq
install_jquery = yes?("Do you want to install jquery (y/n)")
install_bootstrap = yes?("Do you want to install bootstrap (y/n)")
install_select2 = yes?("Do you want to install select2 (y/n)")
install_active_storage = yes?("Do you want to install activestorage (y/n)")

after_bundle do
  run("spring stop")

  run("rails generate simple_form:install") if install_simple_form
  run("rails generate devise:install") if install_devise
  run("rails generate devise user") if install_devise
  run("rails generate graphql:install") if install_graphql
  run("rails generate rollbar") if install_rollbar
  run("bundle exec wheneverize .") if install_whenever
  run("yarn add jquery") if install_jquery
  run("yarn add bootstrap") if install_bootstrap
  run("yarn add select2") if install_select2
  run("rails active_storage:install") if install_active_storage
  insert_into_file 'app/controllers/application_controller.rb', "  protect_from_forgery\n",
                 after: "class ApplicationController < ActionController::Base\n"
  insert_into_file 'config/initializers/devise.rb', "\n  config.omniauth :facebook, '', ''\n",
                 after: "# config.sign_in_after_change_password = true\n"
  insert_into_file 'app/graphql/types/mutation_type.rb', "
    field :auth_change_password,                    resolver: Mutations::Auth::ChangePassword\n
    field :auth_confirm_email,                      resolver: Mutations::Auth::ConfirmEmail\n
    field :auth_forgot_password,                    resolver: Mutations::Auth::ForgotPassword\n
    field :auth_reset_password,                     resolver: Mutations::Auth::ResetPassword\n
    field :auth_login,                              resolver: Mutations::Auth::Login\n
    field :auth_sign_up,                            resolver: Mutations::Auth::SignUp\n",
    after: "class MutationType < Types::BaseObject\n"
  inside 'app' do
    inside 'graphql' do
      inside 'types' do
        inside 'objects' do
          copy_file 'date_time.rb'
          copy_file 'api_key.rb'
          inside 'user' do
            copy_file 'base.rb'
            copy_file 'current_user.rb'
          end
        end
        inside 'inputs' do
          inside 'auth' do
            copy_file 'change_password.rb'
            copy_file 'login.rb'
            copy_file 'reset_password.rb'
            copy_file 'sign_up.rb'
          end
        end
      end
      inside 'mutations' do
        inside 'auth' do
          copy_file 'change_password.rb'
          copy_file 'confirm_email.rb'
          copy_file 'forgot_password.rb'
          copy_file 'login.rb'
          copy_file 'reset_password.rb'
          copy_file 'sign_up.rb'
        end
        copy_file 'auth_mutation_query_type.rb'
        copy_file 'base_mutation.rb'
      end
    end
    if install_active_storage
    	inside 'models' do
				inside 'concerns' do
					copy_file 'attachments.rb'
				end
			end
		end
  end
  if install_sidekiq
	  inside 'config' do
			copy_file 'sidekiq.yml'
		end
	end
  # inside 'app/controllers' do
  #   copy_file 'graphql_controller.rb'
  # end
  rails_command("db:migrate")
end
# generate(:scaffold, "person name:string")
# route "root to: 'people#index'"
