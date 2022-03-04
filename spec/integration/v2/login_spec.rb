# frozen_string_literal: true

require 'swagger_helper'

describe 'Api::V2::LoginController', swagger_doc: 'v2/swagger.yaml' do
  path '/api/v2/login' do
    post 'Login' do
      tags 'Auhorization'
      consumes 'application/json'
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: {
            type: :string,
            example: 'example@simple.me',
            description: 'Email of the user'
          },
          password: {
            type: :string,
            example: 'password',
            description: 'Password of the user'
          },
          remember_me: {
            type: :boolean,
            example: true,
            description: 'Remember me to get the refresh token'
          }
        },
        required: [:email, :password]
      }

      response '200', 'Logged in successfully with the refresh token' do
        schema type: :object,
          properties: {
            data: {
              type: :object,
              properties: {
                token: { type: :string },
                refresh_token: { type: :string },
              },
              required: [:token]
            },
          }

        let!(:user) { User.create(email: 'myemail@gmail.com', password: 'password', name: 'name' ) }
        let(:credentials) { { email: 'myemail@gmail.com', password: 'password', remember_me: true } }
        run_test!
      end

      response '401', 'Unauthorized' do
        schema '$ref': '#/components/schemas/Error'

        let(:credentials) { { email: 'myemail@gmail.com', password: 'password' } }
        run_test!
      end
    end
  end
end
