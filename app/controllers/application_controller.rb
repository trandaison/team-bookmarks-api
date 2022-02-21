class ApplicationController < ActionController::API
  wrap_parameters false
  include Pagy::Backend

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { error: exception.message }, status: :not_found
  end

  rescue_from ActionController::ParameterMissing do |exception|
    render json: { error: exception.message }, status: :bad_request
  end

  private
  def pagy_meta(pagy)
    data = pagy_metadata(@pagy)
    {
      count: data[:count],
      page: data[:page],
      items: data[:items],
      pages: data[:pages],
      last: data[:last],
      in: data[:in],
      from: data[:from],
      to: data[:to],
      prev: data[:prev],
      next: data[:next]
    }
  end
end
