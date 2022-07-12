class PasswordResetsController < ApplicationController
  before_action :find_user, only: %i(create edit update)
  before_action :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user.create_reset_digest
    @user.send_password_reset_email
    flash[:info] = t ".reset_instructions"
    redirect_to root_path
  end

  def edit; end

  def update
    if params[:user][:password].blank?
      @user.errors.add(:password, t(".cant_be_empty"))
      render :edit
    elsif @user.update(user_params)
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = t ".password_been_reset"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def find_user
    @user = User.find_by(email: params[:password_reset][:email]&.downcase ||
                                params[:email]&.downcase)
    return if @user

    redirect_to root_path
    flash[:danger] = t ".user_not_found"
  end

  def valid_user
    return if @user.activated? && @user.authenticated?(:reset, params[:id])

    flash[:danger] = t ".user_not_valid"
    redirect_to root_path
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t ".password_reset_expired."
    redirect_to new_password_reset_url
  end
end
