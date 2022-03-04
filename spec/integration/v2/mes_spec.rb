# frozen_string_literal: true

require 'swagger_helper'

describe 'Api::V2::MesController', swagger_doc: 'v2/swagger.yaml' do
  path '/api/v2/me' do
    get 'Get my profile' do
      tags 'Auhorization'
      security [{ BearerAuth: [] }]

      response '200', 'Success' do
        schema '$ref': '#/components/schemas/User'
        let!(:user) { User.create(email: 'email@gmail.com', password: 'password', name: 'name' ) }
        let(:BearerAuth) { 'Bearer ' + user.issue_jwt_token }
        run_test!
      end

      response '401', 'Unauthorized' do
        schema '$ref': '#/components/schemas/Error'
        let(:BearerAuth) { 'Bearer ' + user.issue_jwt_token }
        run_test!
      end
    end
  end
end
