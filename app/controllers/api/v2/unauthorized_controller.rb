class Api::V2::UnauthorizedController < Api::V2::BaseController
  skip_before_action :authorized
end
