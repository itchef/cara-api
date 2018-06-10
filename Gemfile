source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.2.0'
# Use postgresql as the database for Active Record
gem 'pg', '1.0.0'
# Use Puma as the app server
gem 'puma', '3.11.2'
gem 'rack-cors', '1.0.2'

# Presenter
gem 'oprah', '0.3.0'

# Auth
gem 'rails_api_auth', '0.1.0'

group :development, :test do
  gem 'pry', '0.11.3'
  gem 'rspec-rails', '3.7.2'
  gem 'factory_bot_rails', '4.8.2'
  gem 'shoulda-matchers', '3.1.2'
  gem 'faker', '1.8.7'
  gem 'database_cleaner', '1.6.2'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'simplecov', require: false, group: :test
