require 'sinatra'
require "sinatra/reloader"
require 'sinatra/content_for'
require 'securerandom'
require 'tilt/erubis'

SESSION_SECRET ||= "56e948b83fa31be8fe371d10c211cae1e979d555473c4fbe76ead56d9d481e5d".freeze

configure do
  set :erb, :escape_html => true
end
# Routes

get '/' do
  # redirect('/users/signin') unless user_logged_in?

  redirect('/contacts')
end

get '/users/signin' do
  erb :sign_in
end

get '/contacts' do
  erb :contacts
end

get '/contacts/new' do
  erb :new_contact
end

post '/contacts/new' do

end

get '/users/new' do
  erb :new_user
end
