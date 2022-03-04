class Api::V2::LogoutsController < Api::V2::BaseController
  def destroy
    render status: :no_content if @current_user.present?
  end
end
