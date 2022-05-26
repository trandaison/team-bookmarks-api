class Api::V2::RefreshTokensController < Api::V2::BaseController
  skip_before_action :authorized, only: :create
  before_action :validate_token, only: :create

  def create
    user_id = decoded_token[0]['user_id']
    @user = User.find_by(id: user_id)
    if @user
      render json: as_json({
        token: @user.issue_jwt_token,
        refresh_token: @user.issue_jwt_token(type: :refresh)
      }), status: :ok
    else
      render json: as_json_error(message: 'Unauthorized'), status: :unauthorized
    end
  end

  private

  def validate_token
    render json: as_json_error(message: 'Invalid token'), status: :unauthorized if params[:token].blank?
  end

  def decoded_token
    JWT.decode(params[:token], ENV['JWT_SECRET'], true, algorithm: 'HS256')
  end
end
