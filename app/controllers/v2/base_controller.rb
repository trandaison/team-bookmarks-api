class V2::BaseController < ActionController::Base
  skip_before_action :verify_authenticity_token

  layout 'application'
end
