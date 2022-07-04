# frozen_string_literal: true

require 'swagger_helper'

describe 'Blogs API' do
  path '/api/v1/logout' do
    delete 'Logout' do
      tags 'Auhorization'
      consumes 'application/json'
      produces 'application/json'
      security [{ Authorization: [] }]

      response '204', 'Logged out successfully' do
        let!(:user) { User.create(email: 'email@gmail.com', password: 'password', name: 'name' ) }
        let(:Authorization) { 'Bearer ' + user.issue_jwt_token }

        run_test!
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { 'Bearer OK' }
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
