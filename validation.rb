def valid_credentials?(name, password, new: false)
  if new
    valid_profile_name?(name) && valid_password?(password)
  else
    name == session[:profile_name] && session[:password] == password
  end
end

def valid_profile_name?(name)
  name.match?(/[A-Za-z\d]{3,}/) && !File.readlines('users.txt').map(&:strip).include?(name)
end

def valid_password?(password)
  password.match? /[A-Za-z\d]{3,}/
end 
