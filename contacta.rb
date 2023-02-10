require 'sinatra'
require "sinatra/reloader"
require 'sinatra/content_for'
require 'securerandom'
require 'tilt/erubis'

SESSION_SECRET = "56e948b83fa31be8fe371d10c211cae1e979d555473c4fbe76ead56d9d481e5d".freeze

get '/' do
  # redirect('/users/signin') unless user_logged_in?

  erb :index
end

get '/signin' do
end

get '/contacts' do
end

get '/new_user' do
end

get '/contacts/new' do 
end


# 1. not logged in

# 2. sign in

# 3. create new user

# 4. contacts (cards) (main) (home screen when user logged in)

# 5. create new contact
