class Api::V1::MesController < ApplicationController
  def show
    render json: { user: @current_user.as_json(except: %i[password_digest id admin]) }, status: :ok
  end
end
