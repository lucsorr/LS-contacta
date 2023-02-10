def add_user(username)
  File.open('users.txt', 'a+') do |file|
    file.write username
  end
end

def user_logged_in?
  session[:logged_in]
end

def store_contact(params)
  contact_id = SecureRandom.hex(8)
  session[:contacts][contact_id] = {}

  params.keys.each do |param|
    session[:contacts][contact_id][param] = params[param]
  end
end