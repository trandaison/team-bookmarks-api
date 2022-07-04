# frozen_string_literal: true

require 'swagger_helper'

describe 'Api::V2::UsersController', swagger_doc: 'v2/swagger.yaml' do
  path '/api/v2/users' do
    post 'Register' do
      tags 'Auhorization'
      consumes 'multipart/form-data'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          'user[name]': {
            type: :string,
            description: 'Within 50 characters'
          },
          'user[email]': {
            type: :string,
          },
          'user[password]': {
            type: :string,
            description: 'At least 8 characters'
          },
          'user[avatar]': {
            type: :string,
            format: :binary,
          }
        },
        required: %w[user[name] user[email] user[password]]
      }
      # parameter name: 'user[name]', in: :formData, type: :string, required: true, description: 'Within 50 characters'
      # parameter name: 'user[email]', in: :formData, type: :string, required: true
      # parameter name: 'user[password]', in: :formData, type: :string, required: true, description: 'At least 8 characters'
      # parameter name: 'user[avatar]', in: :formData, type: :file, required: false

      response '201', 'Register successfully' do
        schema type: :object,
          properties: {
            data: {
              '$ref': '#/components/schemas/User'
            }
          },
          required: %w[data]

        # let('user[name]') { 'name' }
        # let('user[email]') { 'myemail@gmail.com' }
        # let('user[password]') { 'password' }
        let(:user) { { user: {} } }
        run_test!
      end

      response '422', 'Register failed' do
        schema '$ref': '#/components/schemas/Error'

        # let('user[name]') { '' }
        # let('user[email]') { '' }
        # let('user[password]') { '' }
        let(:user) { { user: {} } }
        run_test!
      end
    end
  end
end
