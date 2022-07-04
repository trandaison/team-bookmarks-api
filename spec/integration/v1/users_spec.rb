# frozen_string_literal: true

require 'swagger_helper'

describe 'Api::V1::UsersController' do
  path '/api/v1/users' do
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
            user: {
              type: :object,
              properties: {
                email: { type: :string },
                name: { type: :string },
                avatar: {
                  type: :object,
                  properties: {
                    url: { type: :string },
                  },
                  required: %w[url]
                },
                created_at: { type: :string },
                updated_at: { type: :string },
              },
              required: %w[email name avatar created_at updated_at]
            }
          },
          required: %w[user]

        # let('user[name]') { 'name' }
        # let('user[email]') { 'myemail@gmail.com' }
        # let('user[password]') { 'password' }
        let(:user) { { user: {} } }
        run_test!
      end

      response '422', 'Register failed' do
        schema type: :object,
          properties: {
            name: {
              type: :array,
              items: { type: :string }
            },
            email: {
              type: :array,
              items: { type: :string }
            },
            password: {
              type: :array,
              items: { type: :string }
            },
            avatar: {
              type: :array,
              items: { type: :string }
            },
          }
        # let('user[name]') { '' }
        # let('user[email]') { '' }
        # let('user[password]') { '' }
        let(:user) { { user: {} } }
        run_test!
      end
    end
  end
end
