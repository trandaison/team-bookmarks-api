class Api::V1::MesController < Api::V1::BaseController
  def show
    render json: { user: @current_user.as_json(except: %i[password_digest id admin]) }, status: :ok
  end
end
