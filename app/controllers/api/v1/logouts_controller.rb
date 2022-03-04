class Api::V1::LogoutsController < ApplicationController
  def destroy
    render status: :no_content if @current_user.present?
  end
end
