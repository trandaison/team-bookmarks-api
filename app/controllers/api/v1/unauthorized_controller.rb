class Api::V1::UnauthorizedController < Api::V1::BaseController
  skip_before_action :authorized
end
