class RegistrationController < ApplicationController
  #newUser method is responsible for creating a new instace variable of user model and store it as
  #as an instance variable of RegistrationController

  def newUser
    @user = User.new
    #Here, we are creating a object of User class (which is an instance of User model) and assigned it's
    #address to the instance variable user.
    #If i would not have added the @ symbol before user then the user variable will get destroyed as it's considered as local variable
    #Therefore, @ symbol will make it an instance variable and therefore, it'll be avaialbe to us in the view
    #using which we will create an new user.
  end

  #createUser will be responsible for creating a new user in the db
  def createUser
    user_data = params[:user]
    user_params
    #Now, we have do the following checks:
    # For name:
    #1. Find if the user with the same name exits or not
    #2. If not exits then go ahead and create the user
    #For password:
    #1. We will check if the password && password_confirmation are same or not only then we will consider
    # And finally, we will set the role as "Customer" and status as "Active"
    @user = User.new(name: user_data[:name], password: user_data[:password], password_confirmation: user_data[:password_confirmation], role: "customer", status: "active")
    if @user.valid? && user_data[:password] == user_data[:password_confirmation]
      if @user.save
        # now that the user is created we need to sign-in the user
        # Therefore, we will use session cookie to make sure the data is kept in encrypted form.
        session[:user_id] = @user.id
        session[:view] = 1
        redirect_to cafeteria_path
        #we can track the session now.
      end
    else
      render :newUser
    end
  end

  # add_clerk is responsible for adding the cleark in the database
  # But, only admin can be allowed to create the clerk user.

  def add_clerk
    if checkIfAdmin
      if params[:password] == params[:password_confirmation]
        clerk = User.new(name: params[:name], password: params[:password], password_confirmation: params[:password_confirmation], role: "clerk", status: "active")
        if clerk.valid?
          clerk.save
        end
      end
    end
    redirect_to cafeteria_path
  end

  private

  def checkIfAdmin
    if session[:view] == 2
      return true
    end
    return false
  end

  def user_params
    # Here, we are gonna validate that we are only geeting email, password and password_conformation from the form
    params.require(:user).permit(:name, :password, :password_confirmation)
  end
end
