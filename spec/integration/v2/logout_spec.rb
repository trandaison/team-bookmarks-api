# frozen_string_literal: true

require 'swagger_helper'

describe 'Api::V2::LogoutsController', swagger_doc: 'v2/swagger.yaml' do
  path '/api/v2/logout' do
    delete 'Logout' do
      consumes 'application/json'
      produces 'application/json'
      tags 'Auhorization'
      security [{ Authorization: [] }]

      response '204', 'Logged out successfully' do
        let!(:user) { User.create(email: 'email@gmail.com', password: 'password', name: 'name' ) }
        let(:Authorization) { 'Bearer ' + user.issue_jwt_token }

        run_test!
      end

      response '401', 'Unauthorized' do
        schema '$ref': '#/components/schemas/Error'
        let(:Authorization) { 'Bearer OK' }
        run_test!
      end
    end
  end
end
