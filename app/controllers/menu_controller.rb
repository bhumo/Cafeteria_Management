class MenuController < ApplicationController
  def show
    @menu_items = Menuitem.all
  end

  def create
    if Menuitem.find_by(name: params[:name])
      @menu_items = Menuitem.all
      flash[:notice] = "Item #{params[:name]} already exists"
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
    Menuitem.destroy_by(id: params[:id])
    flash[:notice] = "Item #{params[:name]} is deleted"
    redirect_to menu_path
  end
end
