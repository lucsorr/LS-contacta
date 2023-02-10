def valid_credentials?(username, password, new: false)
  if new
    valid_username?(username) && valid_password?(password)
  else
    username == session[:username] && session[:password] == password
  end
end

def valid_username?(name)
  name.match?(/[A-Za-z\d]{3,}/) && !File.readlines('users.txt').map(&:strip).include?(name)
end

def valid_password?(text_input)
  text_input.match? /[A-Za-z\d]{3,}/
end 
