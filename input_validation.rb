def valid_credentials?(name, password, new: false)
  if new
    valid_profile_name?(name) && valid_password?(password)
  else
    session[:profiles].include?(name) && session[:profiles][name][:password] == password
  end
end

def valid_profile_name?(name)
  name.match?(/[A-Za-z\d]{3,}/) && !session[:profiles].keys.include?(name)
end

def valid_password?(password)
  password.match? /[A-Za-z\d]{3,}/
end
