class UsersController < ApplicationController
  before_filter :require_login, :only => [:update]
  skip_before_filter :require_login, :only => [:create, :activate]

  def create
    @user = User.new(params[:user])
    @registered = @user.save ? true : false
    
    respond_to do |format|
      format.js
    end
  end

  # PUT /users/1
  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      redirect_to(@user, :notice => 'User was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def activate
    if @user = User.load_from_activation_token(params[:id])
      @user.activate!
      redirect_to(login_path, :notice => 'User was successfully activated.')
    else
      not_authenticated
    end
  end
end
