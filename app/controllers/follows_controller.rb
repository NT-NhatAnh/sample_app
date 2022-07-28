class FollowsController < ApplicationController
  before_action :logged_in_user, :find_user, only: %i(following followers)

  def following
    @title = t ".following"
    @pagy, @users = pagy @user.following, items: Settings.admin.user_per_page
    render :show_follow
  end

  def followers
    @title = t ".followers"
    @pagy, @users = pagy @user.followers, items: Settings.admin.user_per_page
    render :show_follow
  end
end
