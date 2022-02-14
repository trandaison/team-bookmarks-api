class ApplicationController < ActionController::API
  include Pagy::Backend

  def root
    render json: 'PONG'
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
