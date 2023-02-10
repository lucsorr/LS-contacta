require 'sinatra'
require "sinatra/reloader" if development?
require 'sinatra/content_for'
require 'securerandom'
require 'tilt/erubis'
require 'bcrypt'
require 'yaml'

require_relative 'user'
require_relative 'validation'

SESSION_SECRET ||= "56e948b83fa31be8fe371d10c211cae1e979d555473c4fbe76ead56d9d481e5d".freeze

configure do
  enable :sessions
  set :session_secret, SESSION_SECRET
  set :erb, :escape_html => true
end

before do
  session[:contacts] ||= {}
end

# Routes

get '/' do
  redirect '/users/signin' unless user_logged_in?

  redirect '/contacts' 
end

get '/users/new' do 
  erb :new_user
end

post '/users/new' do
  if valid_credentials?(params[:username], params[:password], new: true)
    add_user(params[:username])
    session[:username] = params[:username]
    session[:password] = BCrypt::Password.create(params[:password])
    session[:logged_in] = true

    redirect '/contacts'
  else
    status 422
    erb :new_user
  end
end

get '/users/signin' do
  erb :sign_in
end

post '/users/signin' do
  if valid_credentials?(params[:username], params[:password])
    session[:logged_in] = true
    redirect '/'
  else
    status 401
    erb :sign_in
  end
end

get '/contacts' do
  # Cards
  # If no contacts yet, add button create your new contact (big card)
  session[:contacts] ||= {}
  
  @contacts = session[:contacts]

  erb :contacts
end

get '/contacts/new' do
  session[:contacts] ||= {}

  erb :new_contact
end

post '/contacts/new' do
  store_contact(params)

  redirect '/contacts'
end

get '/users/logout' do
  session[:logged_in] = false

  redirect '/'
end

