class User < ApplicationRecord
  mount_uploader :avatar, ImageUploader
  has_secure_password

  has_many :comments, dependent: :nullify

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, allow_nil: true, length: { minimum: 8, maximum: 72 }

  def issue_jwt_token type: :access
    exp_duration = Settings.jwt_token_exp.try(type)
    raise 'Invalid token type or token expires time settings is missing' unless exp_duration

    exp = Time.current.to_i + exp_duration.minutes.to_i
    payload = { exp: exp }
    if type == :reset_password
      payload.merge!(reset_password_token: reset_password_token)
    else
      payload.merge!(user_id: id)
    end
    JWT.encode(payload, ENV['JWT_SECRET'])
  end

  def send_reset_password_instructions(url: nil)
    raise "This user have no `reset_password_token`, you have to issue a token first!" unless reset_password_token

    UserMailer.reset_password_email(self, url: url).deliver_now
  end
end
