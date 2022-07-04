class Api::V2::LoginController < Api::V2::BaseController
  skip_before_action :authorized, only: %i[create google]
  before_action :set_google_user, only: :google

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      payload = generate_auth_payload(@user, use_refresh_token: params[:remember_me].present?)
      render json: as_json(payload), status: :ok
    else
      render json: as_json_error(message: 'Invalid username or password'), status: :unauthorized
    end
  end

  def google
    render json: as_json(generate_auth_payload(@user)), status: :ok
  end

  private

  def set_google_user
    @user = GoogleApis.new(params[:token_type], params[:access_token]).user_info
    render json: as_json_error(message: 'Invalid Google token'), status: :unauthorized unless @user
  end

  def generate_auth_payload(user, use_refresh_token: true)
    payload = { token: user.issue_jwt_token }
    payload[:refresh_token] = @user.issue_jwt_token(type: :refresh) if use_refresh_token
    payload
  end
end
