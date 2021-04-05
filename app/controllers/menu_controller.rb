class MenuController < ApplicationController
  def show
    @menu_items = Menuitem.where(status: "active")
  end

  def create
    menu_item = Menuitem.find_by(name: params[:name])
    if menu_item
      if menu_item.status == "active"
        flash[:notice] = "Item #{params[:name]} already exists"
      end
      menu_item.status = "active"
      menu_item.save
      @menu_items = Menuitem.where(status: "active")

      render :show
    else
      @menu_item = Menuitem.create(name: params[:name], category_id: params[:category_id], description: params[:description], price: params[:price], status: "active")
      if @menu_item.save
        flash[:success] = "Item #{params[:name]} successfully created"
        render :show
      else
        render :show
      end
    end
  end

  def destroy
    menu_item = Menuitem.find_by(id: params[:id])
    menu_item.status = "deactive"
    menu_item.save
    flash[:notice] = "Item #{params[:name]} is deleted"
    redirect_to menu_path
  end
end
