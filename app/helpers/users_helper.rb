module UsersHelper
  def gravatar_for user, options = {size: Settings.gravatar_size}
    size = options[:size]
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def followed_form
    current_user.active_relationships.build
  end

  def unfollowed_form
    current_user.active_relationships.find_by followed_id: @user.id
  end
end
