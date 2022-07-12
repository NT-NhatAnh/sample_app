class Micropost < ApplicationRecord
  UPDATABLE_ATTRS = %i(content image).freeze

  belongs_to :user
  has_one_attached :image

  delegate :name, to: :user, prefix: :user, allow_nil: true
  validates :content, presence: true,
                      length: {maximum: Settings.micropost.max_content}
  validates :image, content_type: {in: Settings.micropost.image_type,
                                   message: :mess},
                    size: {
                      less_than: Settings.micropost.image_size.megabytes,
                      message: :size_img
                    }

  scope :recent_post, ->{order(created_at: :desc)}
  scope :by_user_ids, ->(user_id){where user_id: user_id}

  def display_image
    image.variant(resize_to_limit: Settings.micropost.image_resize)
  end
end
