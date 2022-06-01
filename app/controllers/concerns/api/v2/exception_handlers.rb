# frozen_string_literal: true

require 'active_support/concern'

module Api
  module V2
    module ExceptionHandlers
      extend ActiveSupport::Concern

      included do
        rescue_from ActiveRecord::RecordNotFound do |exception|
          render json: as_json_error(message: exception.message), status: :not_found
        end

        rescue_from ForbiddenError do |exception|
          render json: as_json_error(message: exception.message), status: :forbidden
        end

        rescue_from ActionController::ParameterMissing do |exception|
          render json: as_json_error(message: exception.message), status: :bad_request
        end

        rescue_from JWT::DecodeError, with: :invalid_token
        rescue_from JWT::ExpiredSignature, with: :expired_token

        def invalid_token
          render(
            json: as_json_error(message: 'Please log in'),
            status: :unauthorized
          )
        end

        def expired_token
          render(
            json: as_json_error(message: 'Token has expired'),
            status: :unauthorized
          )
        end
      end
    end
  end
end
