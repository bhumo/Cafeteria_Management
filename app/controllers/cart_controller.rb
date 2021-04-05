class CartController < ApplicationController

  # show method is responsible for the creating the datastructure of the cart items and for rendenring it in the view
  def show
    cart_obj = Cart.find_by(user_id: session[:user_id])
    if cart_obj
      order_id = cart_obj.order_id
      session[:order_id] = cart_obj.order_id
      @order_items = Orderitem.where(order_id: cart_obj.order_id).order("id")
      session[:count] = countItems
      session[:total] = subTotal
    else
      session[:total] = 0
      session[:count] = 0
    end
  end

  # countItems is responsible for finding total no of items present in Orderitem model
  # for the current logged in user
  def countItems
    order_items_list = Orderitem.where(order_id: session[:order_id])
    count = 0
    if order_items_list
      order_items_list.each do |order_item|
        count = count + order_item.quantity
      end
    end
    return count
  end

  # subtotal is responsible for finding out the total value of all the items present in the cart
  def subTotal
    order_items_list = Orderitem.where(order_id: session[:order_id])
    total = 0
    if order_items_list
      order_items_list.each do |order_item|
        total = total + ((Menuitem.find_by(id: order_item.menuitem_id).price) * order_item.quantity)
      end
    end
    return total
  end

  # decrease method is responsible for reducing the quantity in the cart
  def decrease
    order_item = Orderitem.find_by(id: params[:orderitem_id])
    order_item.quantity -= 1
    order_item.save
    session[:count] = session[:count] - 1
    redirect_to cart_path
  end

  # increase method is responsible for increasing the quantity in the cart
  def increase
    order_item = Orderitem.find_by(id: params[:orderitem_id])
    order_item.quantity += 1
    order_item.save
    session[:count] = session[:count] + 1
    redirect_to cart_path
  end

  # when the quantity will become zero it will destroy the record
  def destroy
    order_item = Orderitem.find_by(id: params[:orderitem_id])
    order_id = order_item
    order_item.destroy()
    count_of_items = Orderitem.where(order_id: order_id).count
    if count_of_items == 0
      Orderitem.destroy_by(id: order_id)
    end
    session[:count] = session[:count] - 1
    redirect_to cart_path
  end

  def add_to_cart
    # we will check if the orderitem already exists for the current user
    cart = Cart.find_by(user_id: session[:user_id])
    if cart
      # if the user have something in the cart already we will just add
      # the item into the already existing order
      order_id = cart.order_id
      order_item = Orderitem.find_by(order_id: order_id, menuitem_id: params[:menuitem_id])
      if order_id == nil
        order_id = Order.create(user_id: session[:user_id], status: "pending")
        session[:order_id] = order_id
        session[:count] = 0
        order_id.save
      end
      if order_item
        order_item.quantity += 1
        order_item.save
      else
        # we will create an orderitem
        order_item = Orderitem.create(order_id: order_id, menuitem_id: params[:menuitem_id], quantity: 1)
        order_item.save
        session[:count] = session[:count] + 1
      end
    else
      render plain: "No cart found"
    end
    redirect_to menu_path
  end

  # checkout method is reponsible for clearing all the data from the cart model/ db and change
  # the status of the order as confirmed
  def checkout
    Cart.destroy_by(user_id: session[:user_id])
    order = Order.find_by(user_id: session[:user_id])
    order.update_columns(status: "confirmed")
    session[:total] = 0
    session[:count] = 0
  end
end
