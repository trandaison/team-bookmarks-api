class Api::V1::LogoutsController < Api::V1::BaseController
  def destroy
    render status: :no_content if @current_user.present?
  end
end
