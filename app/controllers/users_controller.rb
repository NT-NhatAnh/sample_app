class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show new create)
  before_action :find_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy User.incre_order,
                         items: Settings.admin.user_per_page
  end

  def show
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
      @user.send_activation_email
      flash[:info] = t ".check_your_email"
      redirect_to root_url
    else
      flash.now[:danger] = t ".user_not_saved"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".profile_updated"
      redirect_to @user
    else
      flash[:danger] = t ".updating_failed"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:danger] = t ".deleting_user_failed"
    else
      flash[:success] = t ".user_deleted"
    end
    redirect_to users_url
  end

  private
  def user_params
    params.require(:user).permit User::UPDATABLE_ATTRS
  end
end
