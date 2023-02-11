require 'sinatra'
require "sinatra/reloader" if development?
require 'sinatra/content_for'
require 'securerandom'
require 'tilt/erubis'
require 'bcrypt'
require 'yaml'

require_relative 'profile'
require_relative 'validation'

SESSION_SECRET ||= "56e948b83fa31be8fe371d10c211cae1e979d555473c4fbe76ead56d9d481e5d".freeze

configure do
  enable :sessions
  set :session_secret, SESSION_SECRET
  set :erb, :escape_html => true
end

# Routes

get '/' do
  redirect '/profiles/signin' unless profile_logged_in?

  redirect '/contacts' 
end

get '/profiles/new' do 
  erb :new_profile
end

post '/profiles/new' do
  if valid_credentials?(params[:profile_name], params[:password], new: true)
    add_profile(params[:profile_name])
    session[:profile_name] = params[:profile_name]
    session[:password] = BCrypt::Password.create(params[:password])
    session[:logged_in] = true

    redirect '/contacts'
  else
    status 422
    erb :new_profile
  end
end

get '/profiles/signin' do
  erb :sign_in
end

post '/profiles/signin' do
  if valid_credentials?(params[:profile_name], params[:password])
    session[:logged_in] = true
    redirect '/'
  else
    status 401
    erb :sign_in
  end
end

get '/contacts' do
  require_logged_in_profile

  session[:contacts] ||= {}
  @contacts = session[:contacts]

  erb :contacts
end

get '/contacts/new' do
  require_logged_in_profile

  session[:contacts] ||= {}

  erb :new_contact
end

post '/contacts/new' do
  store_contact(params)

  redirect '/contacts'
end

get '/profiles/logout' do
  require_logged_in_profile

  session[:logged_in] = false

  redirect '/'
end

