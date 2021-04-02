class CafeteriaController < ApplicationController
  def customer_view
  end

  def admin_view
  end

  def clerk_view
  end

  def index
    if session[:user_id]
      @user = User.find_by(id: session[:user_id])
      if @user.role == "customer"
        session[:view] = 1
        render :customer_view
      elsif @user.role == "admin"
        session[:view] = 2
        render :admin_view
      elsif @user.role == "clerk"
        session[:view] = 3
        render :clerk_view
      end
    end
  end
end
