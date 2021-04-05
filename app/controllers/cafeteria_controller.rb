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
        session[:count] = countQuantites
        render :customer_view
      elsif @user.role == "admin"
        session[:view] = 2
        session[:count] = countQuantites
        render :admin_view
      elsif @user.role == "clerk"
        session[:view] = 3
        session[:count] = countQuantites
        render :clerk_view
      end
    end
  end

  def countQuantites
    cart = Cart.find_by(user_id: session[:user_id])
    count = 0
    if cart
      orders = Orderitem.find_by(order_id: cart.order_id)
      oders.each do |item|
        count += item.quantity
      end
    end
    return count
  end
end
