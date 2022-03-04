class UnauthorizedController < ApplicationController
  skip_before_action :authorized
end
