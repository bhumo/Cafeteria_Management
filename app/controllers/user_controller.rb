class UserController < ApplicationController
  def show_customers
    users = User.where(role: "customer")
    @user_list = []
    users.each do |user|
      user_hash = Hash.new()
      user_hash[:total_orders] = Order.where("status != ? AND user_id=?", "pending", user.id).count
      user_hash[:status] = user.status
      user_hash[:name] = user.name
      @user_list.push(user_hash)
    end
  end

  def show_clerks
    users = User.where(role: "clerk")
    @user_list = []
    users.each do |user|
      user_hash = Hash.new()
      user_hash[:total_orders] = Order.where("status != ? AND user_id=?", "pending", user.id).count
      user_hash[:status] = user.status
      user_hash[:name] = user.name
      @user_list.push(user_hash)
    end
  end

  def show_chart_by_month
    if session[:view] != 2
      redirect_to cafeteria_path
    end
  end
end
