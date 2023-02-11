def add_profile(name)
  File.open('users.txt', 'a+') { |file| file.write "#{name}\n" }
  end
end

def profile_logged_in?
  session[:logged_in]
end

def store_contact(params)
  contact_id = SecureRandom.hex(4)
  session[:contacts][contact_id] = {}

  params.keys.each { |param| session[:contacts][contact_id][param] = params[param] }
end

def require_logged_in_profile
  redirect '/' unless user_logged_in?
end