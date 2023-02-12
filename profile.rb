def profile
  session[:profiles][current_profile_name]
end

def current_profile_name
  session[:profiles]&.find { |_, prof| prof[:logged_in] }&.[](0)
end

def add_profile(name, password)
  session[:profiles][name] = {}
  session[:profiles][name][:password] = BCrypt::Password.create(params[:password])
  session[:profiles][name][:logged_in] = true
end

def profile_logged_in?
  current_profile_name && profile[:logged_in]
end

def store_contact(parameters)
  contact_id = SecureRandom.hex(4)
  profile[:contacts][contact_id] = {}
  parameters.keys.each do |param|
    value = 
      if param.match?(/email|category/) then parameters[param]
      elsif param.match?(/name/) then parameters[param].split.map(&:capitalize).join(' ')
      else parameters[param].capitalize
      end

    profile[:contacts][contact_id][param] = value
  end
end

def update_contact_data(params, id)
  params.keys.each { |param| profile[:contacts][id][param] = params[param].strip unless param == 'id' }
end

def require_logged_in_profile
  redirect '/' unless profile_logged_in?
end