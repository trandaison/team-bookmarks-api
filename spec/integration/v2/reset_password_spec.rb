# frozen_string_literal: true

require 'swagger_helper'

describe 'Api::V2::ResetPasswordsController', swagger_doc: 'v2/swagger.yaml' do
  path '/api/v2/reset_password' do
    post 'Forgot password' do
      tags 'Reset password'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: {
            type: :string,
            example: 'user@example.com',
            description: 'The user email address'
          },
          reset_password_url: {
            type: :string,
            example: 'http://your-domain.com/reset_password',
            description: "The reset password url from your website, provide this url to get a correct reset password link in the email. A query named `token` will be added to the url, which will be used to identify the user.<br/>For example: If your front-end app is running under localhost:3000, the reset_password_url value should be `http://localhost:3000/reset_password`, then the url in the email will be: `http://localhost:3000/reset_password?token=abc123`"
          },
        },
        required: %w[email]
      }

      response '201', 'Request reset password successfully' do
        let!(:user) { User.create(email: 'myemail@gmail.com', password: 'password', name: 'name' ) }
        let(:credentials) { { email: user.email } }
        run_test!
      end

      response '404', 'Email does not exist' do
        schema schema '$ref': '#/components/schemas/Error'
        let(:credentials) { { email: 'no-reply@gmail.com' } }
        run_test!
      end
    end

    get 'Verify a reset password token' do
      tags 'Reset password'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :token, in: :query, type: :string, required: true, description: 'The reset password token from the URL in the email'

      response '200', 'The token is valid' do
        schema type: :object,
          properties: {
            data: {
              type: :object,
              properties: {
                user: {
                  type: :object,
                  properties: {
                    email: { type: :string },
                    name: { type: :string },
                  },
                  required: %w[email name]
                },
              },
              required: %w[user]
            },
          },
          required: %w[data]

        let!(:user) { User.create(email: 'myemail@gmail.com', password: 'password', name: 'name', reset_password_token: 'aaa' ) }
        let(:token) { user.issue_jwt_token(type: :reset_password) }
        run_test!
      end

      response '400', 'The token has expired or invalid' do
        schema schema '$ref': '#/components/schemas/Error'
        let(:token) { 'golden-token' }
        run_test!
      end

      response '404', 'The token has already been used' do
        schema schema '$ref': '#/components/schemas/Error'
        let!(:user) { User.create(email: 'myemail@gmail.com', password: 'password', name: 'name', reset_password_token: 'new-token') }
        let!(:token) { user.issue_jwt_token(type: :reset_password) }
        let!(:reset_password_token) { user.update(reset_password_token: nil) }
        run_test!
      end
    end

    put 'Reset password' do
      tags 'Reset password'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          password: {
            type: :string,
            description: 'New password'
          },
          token: {
            type: :string,
            description: "The reset password token"
          },
        },
        required: %w[password token]
      }

      response '200', 'Password updated successfully' do
        let!(:user) { User.create(email: 'myemail@gmail.com', password: 'password', name: 'name', reset_password_token: 'fff' ) }
        let(:token) { user.issue_jwt_token(type: :reset_password) }
        let(:credentials) { { password: 'new-password', token: token } }
        run_test!
      end

      response '400', 'The token has expired or invalid' do
        schema schema '$ref': '#/components/schemas/Error'
        let(:credentials) { { password: 'new-password', token: 'token' } }
        run_test!
      end

      response '404', 'The token has already been used' do
        schema schema '$ref': '#/components/schemas/Error'
        let!(:user) { User.create(email: 'myemail@gmail.com', password: 'password', name: 'name', reset_password_token: 'new-token') }
        let!(:token) { user.issue_jwt_token(type: :reset_password) }
        let!(:reset_password_token) { user.update(reset_password_token: nil) }
        let(:credentials) { { password: 'new-password', token: token } }
        run_test!
      end
    end
  end
end
