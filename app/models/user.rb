class User < ApplicationRecord
  mount_uploader :avatar, ImageUploader
  has_secure_password

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 8, maximum: 255 }

  def issue_jwt_token type: :access
    exp_duration = Settings.jwt_token_exp.try(type)
    raise 'Invalid token type or token expires time settings is missing' unless exp_duration

    exp = Time.current.to_i + exp_duration.minutes.to_i
    payload = { user_id: id, exp: exp }
    JWT.encode(payload, ENV['JWT_SECRET'])
  end
end
