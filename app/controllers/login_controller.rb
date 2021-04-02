class LoginController < ApplicationController
  def userlogin
    if session[:user_id]
      # if the user is already logged in then we will redirect that user to home page
      # ehich in our case is cafeteria page
      redirect_to cafeteria_path
    end
  end
end
