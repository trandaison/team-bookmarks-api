class Api::V2::LoginController < Api::V2::BaseController
  skip_before_action :authorized, only: :create

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      payload = { token: @user.issue_jwt_token }
      payload[:refresh_token] = @user.issue_jwt_token(type: :refresh) if params[:remember_me]
      render json: as_json(payload), status: :ok
    else
      render json: as_json_error(message: 'Invalid username or password'), status: :unauthorized
    end
  end
end
