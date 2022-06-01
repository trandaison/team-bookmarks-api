# frozen_string_literal: true

module Api
  module V2
    class BaseController < ApplicationController
      before_action :authorized
      wrap_parameters false
      include Pagy::Backend
      include Api::V2::ExceptionHandlers


      def auth_header
        request.headers['Authorization']
      end

      def decoded_token
        return unless auth_header

        token = auth_header.split(' ')[1]
        JWT.decode(token, ENV['JWT_SECRET'], true, algorithm: 'HS256')
      end

      def current_user
        decoded = decoded_token
        return unless decoded

        user_id = decoded[0]['user_id']
        @current_user ||= User.find_by(id: user_id)
      end

      def logged_in?
        current_user.present?
      end

      def authorized
        return if logged_in?

        render json: as_json_error(message: 'Please log in'), status: :unauthorized
      end

      def as_json_list(records, pagy = nil)
        {
          data: { items: records },
          pagination: pagy ? pagy_meta(pagy) : {}
        }
      end

      def as_json(data)
        { data: data }
      end

      def as_json_error(errors_details = [], message: 'Validation failed')
        {
          type: :validation,
          status: :bad_request,
          path: '',
          message: message,
          error_code: :bad_request,
          errors: errors_details
        }
      end

      private

      def pagy_meta(pagy)
        data = pagy_metadata(pagy)
        {
          count: data[:count],
          page: data[:page],
          offset: data[:items],
          total: data[:pages],
          prev: data[:prev],
          next: data[:next]
        }
      end
    end
  end
end
