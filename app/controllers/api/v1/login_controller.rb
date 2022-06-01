class Api::V1::LoginController < Api::V1::UnauthorizedController
  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      payload = { token: @user.issue_jwt_token }
      payload[:refresh_token] = @user.issue_jwt_token(type: :refresh) if params[:remember_me]
      render json: payload, status: :ok
    else
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end
  end
end
