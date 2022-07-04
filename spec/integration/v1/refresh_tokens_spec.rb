# frozen_string_literal: true

require 'swagger_helper'

describe 'Blogs API' do
  path '/api/v1/refresh_tokens' do
    post 'Refresh Access Token' do
      tags 'Auhorization'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          token: {
            type: :string,
            example: 'some-token',
            description: 'The refresh token'
          },
        }
      }

      response '200', 'Token has been reset successfully' do
        schema type: :object,
          properties: {
            token: { type: :string },
            refresh_token: { type: :string },
          },
          required: %w[token refresh_token]

        let!(:user) { User.create(email: 'myemail@gmail.com', password: 'password', name: 'name' ) }
        let(:credentials) { { token: user.issue_jwt_token(type: :refresh) } }
        run_test!
      end

      response '401', 'Unauthorized' do
        schema type: :object,
          properties: {
            error: { type: :string },
          },
          required: %w[error]
        let(:credentials) { { token: 'myemail@gmail.com' } }
        run_test!
      end
    end
  end
end
