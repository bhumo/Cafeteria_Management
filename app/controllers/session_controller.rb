class SessionController < ApplicationController
  def create
    if params[:password] == params[:password_confirmation]
      # if passwords match then only we move ahead
      user = User.find_by(name: params[:name])
    end
    if user.present? && user.authenticate(params[:password])
      session[:user_id] = user.id
      session[:user_name] = user.name
      session[:view] = 2
      redirect_to cafeteria_path
    else
      render plain: "Invalid"
    end
  end

  def destroy
    # destroy method will be responsible for destroying the data from the sesssion cookies
    # and further logout the user as well.
    session[:user_id] = nil
    session[:name] = nil
    session[:view] = nil
    if @user
      @user = nil
    end
    redirect_to cafeteria_path
  end
end
