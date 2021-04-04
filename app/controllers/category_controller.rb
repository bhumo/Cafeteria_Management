class CategoryController < ApplicationController
  def create
    name = params[:name]
    name = name.strip()
    name = name.downcase
    if Category.find_by(name: name) == nil
      @category = Category.new(name: params[:name])
      flash[:notice] = "Category #{name} is created"
    else
      flash[:notice] = "Category #{name} is not created"
    end
    redirect_to menu_path
  end
end
