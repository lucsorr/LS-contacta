require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/content_for'
require 'securerandom'
require 'tilt/erubis'
require 'bcrypt'

require_relative 'profile'
require_relative 'input_validation'

SESSION_SECRET ||= '56e948b83fa31be8fe371d10c211cae1e979d555473c4fbe76ead56d9d481e5d'.freeze

configure do
  enable :sessions
  set :session_secret, SESSION_SECRET
  set :erb, escape_html: true
end

# Before-routes filters

before do
  session[:profiles] ||= {}
end

before '/contacts/*' do
  profile[:contacts] ||= {}
end

# Routes

# Index page
get '/' do
  redirect '/profiles/signin' unless profile_logged_in?

  redirect '/contacts'
end

# Add new profile/user
get '/profiles/new' do
  erb :new_profile
end

post '/profiles/new' do
  if valid_credentials?(params[:profile_name], params[:password], new: true)

    add_profile(params[:profile_name], params[:password])

    redirect '/contacts'
  else
    status 422
    erb :new_profile
  end
end

# Profile signin
get '/profiles/signin' do
  erb :sign_in
end

post '/profiles/signin' do
  if valid_credentials?(params[:profile_name], params[:password])
    session[:profiles][params[:profile_name]][:logged_in] = true

    redirect '/'
  else
    status 401
    erb :sign_in
  end
end

# Display profile contacts
get '/contacts' do
  profile[:contacts] ||= {}

  require_logged_in_profile

  @contacts = profile[:contacts].sort_by { |_, data| data['name'].downcase }

  erb :contacts
end

# Add new contact
get '/contacts/new' do
  profile[:contacts] ||= {}

  require_logged_in_profile

  erb :new_contact
end

post '/contacts/new' do
  store_contact(params)

  redirect '/contacts'
end

# Edit contact
get '/contacts/edit/:id' do |id|
  @data = profile[:contacts][id]

  erb :edit_contact
end

post '/contacts/edit/:id' do |id|
  update_contact_data(params, id)


  redirect '/contacts'
end

# Delete contact
post '/contacts/delete/:id' do |id|
  profile[:contacts].delete id

  redirect '/contacts'
end

# Profile logout
get '/profiles/logout' do
  require_logged_in_profile

  profile[:logged_in] = false

  redirect '/'
end
