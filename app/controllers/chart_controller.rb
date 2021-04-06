class ChartController < ApplicationController
  def newUserToday
    if session[:view] != 2
      redirect_to cafeteria_path
    end
    render json: User.group_by_month(:created_at).count
  end

  def new_user_month
    if session[:view] != 2
      redirect_to cafeteria_path
    end
    render json: User.group_by_month_of_year(:created_at).count.map { |k, v| [I18n.t("date.month_names")[k], v] }
  end

  def orders_by_month
    if session[:view] != 2
      redirect_to cafeteria_path
    end
    monthly_counts = Orderitem.select("created_at, menuitem_id, quantity")
    total = Hash.new()
    monthly_counts.each do |item|
      menuItem = Menuitem.find_by(id: item.menuitem_id)
      if menuItem
        total[item.created_at.month] = Menuitem.find_by(id: item.menuitem_id).price * item.quantity
      end
    end
    for i in 1...13
      if total[i] == nil
        total[I18n.t("date.month_names")[i]] = 0
      else
        value = total[i]
        total[I18n.t("date.month_names")[i]] = value
        total.delete(i)
      end
    end

    render json: total
  end
end
