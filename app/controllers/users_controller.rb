class UsersController < ApplicationController
  def show
    @user = User.find params[:id]
    return if @user

    flash[:danger] = t ".user_not_found"
    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t ".welcome_to_the_sampleapp!"
      redirect_to @user
    else
      flash.now[:danger] = t ".user_not_saved"
      render :new
    end
  end

  private
  def user_params
    params.require(:user).permit User::UPDATABLE_ATTRS
  end
end
