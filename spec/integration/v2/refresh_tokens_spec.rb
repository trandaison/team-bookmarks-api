# frozen_string_literal: true

require 'swagger_helper'

describe 'Api::V2::RefreshTokensController', swagger_doc: 'v2/swagger.yaml' do
  path '/api/v2/refresh_tokens' do
    post 'Refresh Access Token' do
      tags 'Auhorization'
      consumes 'application/json'
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          token: {
            type: :string,
            example: 'sometoken628396',
            description: 'The refresh token'
          },
        }
      }

      response '200', 'Token has been reset successfully' do
        schema type: :object,
          properties: {
            data: {
              type: :object,
              properties: {
                token: { type: :string },
                refresh_token: { type: :string },
              },
              required: %w[token refresh_token]
            },
          },
          required: %w[data]

        let!(:user) { User.create(email: 'myemail@gmail.com', password: 'password', name: 'name' ) }
        let(:credentials) { { token: user.issue_jwt_token(type: :refresh) } }
        run_test!
      end

      response '401', 'Unauthorized' do
        schema '$ref': '#/components/schemas/Error'
        let(:credentials) { { token: 'myemail@gmail.com' } }
        run_test!
      end
    end
  end
end
