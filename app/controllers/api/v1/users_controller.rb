class Api::V1::UsersController < Api::V1::BaseController
  skip_before_action :authorized

  def create
    @user = User.new(user_params)

    if @user.save
      render json: { user: @user.as_json(except: %i[password_digest id admin]) }, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :avatar)
  end
end
