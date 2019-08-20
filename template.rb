# template.rb
require 'byebug'
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

after_bundle do
  run("spring stop")

  run("rails generate simple_form:install") if install_simple_form
  run("rails generate devise:install") if install_devise
  rails_command("db:migrate")
end
# generate(:scaffold, "person name:string")
# route "root to: 'people#index'"
