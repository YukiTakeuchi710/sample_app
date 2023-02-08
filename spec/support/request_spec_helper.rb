module RequestSpecHelper

  def sign_in(user)
    post login_path,  params: { session: {email: user.email, password: user.password} }
  end

  def sign_out(user)
    logout(user)
  end


end