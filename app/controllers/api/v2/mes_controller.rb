class Api::V2::MesController < Api::V2::BaseController
  def show
    render json: as_json(@current_user.as_json(except: %i[password_digest id admin])), status: :ok
  end
end
