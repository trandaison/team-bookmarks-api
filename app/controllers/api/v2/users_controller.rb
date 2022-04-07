class Api::V2::UsersController < Api::V2::BaseController
  skip_before_action :authorized

  def create
    @user = User.new(user_params)

    if @user.save
      render json: as_json(@user.as_json(except: %i[password_digest id admin])), status: :created
    else
      render json: as_json_error(@user.errors_details), status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :avatar)
  end
end
