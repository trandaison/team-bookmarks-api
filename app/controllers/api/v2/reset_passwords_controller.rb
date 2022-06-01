class Api::V2::ResetPasswordsController < Api::V2::UnauthorizedController
  include ActionController::MimeResponds

  skip_before_action :authorized
  before_action :set_user, only: %i[show update]

  def create
    @user = User.find_by!(email: params[:email])
    @user.update_attribute(:reset_password_token, SecureRandom.urlsafe_base64)
    @user.send_reset_password_instructions(url: params[:reset_password_url].presence)
    render json: nil, status: :created
  end

  def show
    render json: as_json({
      user: @user.as_json(only: %i[name email])
    }), status: :ok
  end

  def update
    password = params[:password].to_s
    if password.blank?
      @user.errors.add(:password, :blank)
      render json: as_json_error(@user.errors_details), status: :unprocessable_entity
      return
    end

    @user.update(password: password, reset_password_token: nil)
    if @user.save
      render json: nil, status: :ok
    else
      render json: as_json_error(@user.errors_details), status: :unprocessable_entity
    end
  end

  private

  def decoded_token
    JWT.decode(params[:token], ENV['JWT_SECRET'], true, algorithm: 'HS256')
  end

  def set_user
    reset_password_token = decoded_token[0]['reset_password_token']
    @user = User.find_by!(reset_password_token: reset_password_token)
  rescue JWT::ExpiredSignature
    render(json: as_json_error(message: 'Token has expired'), status: :bad_request)
  rescue JWT::DecodeError
    render(json: as_json_error(message: 'Invalid token'), status: :bad_request)
  rescue ActiveRecord::RecordNotFound
    render json: as_json_error(message: 'This URL has already been used or no longer valid'), status: :not_found
  end
end
