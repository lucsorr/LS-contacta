def profile
  session[:profiles][current_profile]
end

def current_profile
  session[:profiles]&.find { |_, prof| prof[:logged_in] }&.[](0)
end

def add_profile(name, password)
  session[:profiles][name] = {}
  session[:profiles][name][:password] = BCrypt::Password.create(params[:password])
  session[:profiles][name][:logged_in] = true
end

def profile_logged_in?
  current_profile && profile[:logged_in]
end

def store_contact(params)
  contact_id = SecureRandom.hex(4)
  profile[:contacts][contact_id] = {}

  params.keys.each { |param| profile[:contacts][contact_id][param] = params[param] }
end

def update_contact_data(params, id)
  params.keys.each { |param| profile[:contacts][id][param] = params[param] }
end

def require_logged_in_profile
  redirect '/' unless profile_logged_in?
end