class User < ApplicationRecord
  attr_accessor :remember_token

  UPDATABLE_ATTRS = %i(name email password password_confirmation).freeze
  before_save :downcase_email

  validates :name, presence: true, length: {maximum: Settings.user.name_max}
  validates :email, presence: true, length: {maximum: Settings.user.email_max},
    format: {with: Settings.user.email_regex},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.user.pass_min}
  has_secure_password

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated? remember_token
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  # Forgets a user.
  def forget
    update_attribute :remember_digest, nil
  end

  class << self
    # Returns the hash digest of the given string.
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    # Returns a random token.
    def new_token
      SecureRandom.urlsafe_base64
    end
end

  private

  def downcase_email
    email.downcase!
  end
end
