class OrderController < ApplicationController
  def show_history
    # we will shoe_histroy only if the user exits
    # therefore, we will check the log-in criteria using a if condition
    # if user is not logged in then we will redirect the guest user to cafteria_path
    if session[:user_id]
      # check if the user is admin to do so and avoid quering role of user over and over again in db
      # i have set the variable view in the session object in which if it's value is 2 then we will show the
      # the admin view
      if session[:view] == 2
        orders = Order.where("status = ? OR status = ? ", "confirmed", "delivered").order("id")
        @order_items_list = []
        orders.each do |order|
          order_hash = Hash.new()
          order_hash[:order_id] = order.id
          order_hash[:total] = 0
          order_hash[:count] = 0
          order_hash[:status] = order.status
          order_hash[:created_at] = order.created_at.to_date
          orderitem = Orderitem.where(order_id: order.id)
          orderitem.each do |item|
            order_hash[:total] += ((Menuitem.find_by(id: item.menuitem_id).price) * item.quantity)
            order_hash[:count] += (item.quantity)
          end
          @order_items_list.push(order_hash)
        end
      else
        # if the control reaches here then it means, the user is either a customer or clerk
        orders = Order.where(user_id: session[:user_id]).order("id")
        @order_items_list = []
        orders.each do |order|
          order_hash = Hash.new()
          order_hash[:order_id] = order.id
          order_hash[:total] = 0
          order_hash[:count] = 0
          order_hash[:status] = order.status
          order_hash[:created_at] = order.created_at.to_date
          orderitem = Orderitem.where(order_id: order.id)
          orderitem.each do |item|
            order_hash[:total] += ((Menuitem.find_by(id: item.menuitem_id).price) * item.quantity)
            order_hash[:count] += (item.quantity)
          end
          @order_items_list.push(order_hash)
        end
      end
    else
      # the control will reach here if the session[:user_id ] doesn't exists or it's value is nil
      # that means the user is not logged in
      redirect_to cafteria_path
    end
  end

  def change_status
    if session[:view] == 2
      order_id = params[:order_id]
      order = Order.find_by(id: order_id)
      order.status = params[:status]
      order.save
      redirect_to orderHistory_path
    else
      # the control will reach here if the session[:user_id ] doesn't exists or it's value is nil
      # that means the user is not logged in
      redirect_to cafteria_path
    end
  end

  def more_info
    #more_info will render the entire information about a particular order
    order = Order.find_by(id: params[:order_id])
    @order_items_list = []
    @subTotal = 0
    @totalItems = 0
    @orderId = order.id
    @created_at = order.created_at.to_date
    @status = order.status.capitalize()
    order_items = Orderitem.where(order_id: order.id)
    order_items.each do |item|
      order_hash = Hash.new()
      order_hash[:item_id] = item.id
      menu_item = Menuitem.find_by(id: item.menuitem_id)
      order_hash[:total] = (menu_item.price * item.quantity)
      order_hash[:count] = (item.quantity)
      @subTotal += order_hash[:total]
      @totalItems += order_hash[:count]
      order_hash[:name] = menu_item.name.capitalize()
      @order_items_list.push(order_hash)
    end
  end
end
