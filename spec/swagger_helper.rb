# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.3',
      info: {
        title: 'API Placeholder',
        version: 'v1'
      },
      paths: {},
      servers: [
        {
          url: '{heroku}',
          variables: {
            heroku: {
              default: ENV.fetch('HOST') { 'https://api-placeholder.herokuapp.com' }
            }
          }
        },
        {
          url: '{localhost}',
          variables: {
            localhost: {
              default: ENV.fetch('HOST') { 'http://localhost:3000' }
            }
          }
        }
      ],
    },
    'v2/swagger.yaml' => {
      openapi: '3.0.3',
      info: {
        title: 'API Placeholder V2',
        version: 'v2'
      },
      paths: {},
      servers: [
        {
          url: '{heroku}',
          variables: {
            heroku: {
              default: ENV.fetch('HOST') { 'https://api-placeholder.herokuapp.com' }
            }
          }
        },
        {
          url: '{localhost}',
          variables: {
            localhost: {
              default: ENV.fetch('HOST') { 'http://localhost:3000' }
            }
          }
        }
      ],
      components: {
        securitySchemes: {
          BearerAuth: {
            type: :http,
            scheme: :bearer
          }
        },
        securitySchemes: {
          BearerAuth: {
            type: :http,
            scheme: :bearer
          }
        },
        schemas: {
          Blog: {
            type: :object,
            properties: {
              id: { type: :integer },
              title: {
                type: :string,
                example: 'My Blog',
                description: 'Title of the blog'
              },
              content: {
                type: :string,
                example: 'My Blog Content',
                description: 'Content of the blog'
              },
              image: {
                type: :object,
                properties: {
                  url: {
                    type: :string,
                    example: 'http://localhost:3000/images/fallback/default.png',
                    description: 'Image of the blog'
                  }
                },
                required: %w[url]
              },
              created_at: {
                type: :string,
                example: '2019-01-01T00:00:00.000Z',
                description: 'Created at of the blog'
              },
              updated_at: {
                type: :string,
                example: '2019-01-01T00:00:00.000Z',
                description: 'Updated at of the blog'
              }
            },
            required: %w[id title content image created_at updated_at]
          },
          User: {
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
          },
          Pagination: {
            type: :object,
            properties: {
              count: {
                type: :number,
                description: 'Total number of items'
              },
              page: {
                type: :number,
                description: 'Current page'
              },
              offset: {
                type: :number,
                description: 'Items per page'
              },
              total: {
                type: :number,
                description: 'Total number of pages'
              },
              prev: {
                type: :number,
                description: 'Previous page'
              },
              next: {
                type: :number,
                description: 'Next page'
              },
            },
            required: %w[count page offset total prev next]
          },
          Error: {
            type: :object,
            properties: {
              message: {
                type: :string
              },
              type: {
                type: :string
              },
              status: {
                type: :string
              },
              path: {
                type: :string
              },
              error_code: {
                type: :string
              },
              errors: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    field: {
                      type: :string
                    },
                    code: {
                      type: :string
                    },
                    message: {
                      type: :string
                    },
                  },
                  required: %w[field code message]
                },
              },
            },
            required: %w[message type status path error_code errors]
          },
        },
      },
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :yaml
end
