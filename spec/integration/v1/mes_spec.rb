# frozen_string_literal: true

require 'swagger_helper'

describe 'Api::V1::MesController' do
  path '/api/v1/me' do
    get 'Get my profile' do
      tags 'Auhorization'
      security [{ BearerAuth: [] }]

      response '200', 'Success' do
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

        let!(:user) { User.create(email: 'email@gmail.com', password: 'password', name: 'name' ) }
        let(:BearerAuth) { 'Bearer ' + user.issue_jwt_token }
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:BearerAuth) { 'Bearer ' + user.issue_jwt_token }
        schema type: :object,
          properties: {
            error: { type: :string },
          },
          required: %w[error]
        run_test!
      end
    end
  end
end
