# frozen_string_literal: true

require 'swagger_helper'

describe 'Api::V2::BlogsController', swagger_doc: 'v2/swagger.yaml' do
  path '/api/v2/blogs' do
    post 'Creates a blog' do
      tags 'Blogs'
      consumes 'multipart/form-data'
      produces 'application/json'
      parameter name: :blog, in: :body, schema: {
        type: :object,
        properties: {
          'blog[title]': {
            type: :string,
            example: 'My Blog',
            description: 'Title of the blog'
          },
          'blog[content]': {
            type: :string,
            example: 'My Blog Content',
            description: 'Content of the blog'
          },
          'blog[image]': {
            type: :string,
            format: :binary,
            description: 'Image of the blog'
          }
        },
        required: %w[blog[title] blog[content]]
      }

      response '201', 'Blog created' do
        schema '$ref' => '#/components/schemas/Blog'
        let(:blog) { { blog: { title: 'foo', content: 'bar' } } }
        run_test!
      end

      response '422', 'Unprocessable entity' do
        schema '$ref' => '#/components/schemas/Error'
        let(:blog) { { blog: { title: 'foo' } } }
        run_test!
      end
    end
  end

  path '/api/v2/blogs/{id}' do
    get 'Retrieves a blog by id' do
      tags 'Blogs'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'Blog found' do
        schema type: :object,
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
              }
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
          }

        let(:id) { Blog.create(title: 'foo', content: 'bar', image: '').id }
        run_test!
      end

      response '404', 'Blog not found' do
        schema '$ref': '#/components/schemas/Error'
        let(:id) { 'foo' }
        run_test!
      end
    end
  end

  path '/api/v2/blogs' do
    get 'Retrieves blogs as a list' do
      tags 'Blogs'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :page, in: :query, type: :number, description: 'Page number. Default is `1`', required: false
      parameter name: :offset, in: :query, type: :number, description: 'Number of items per page. Default is `20`', required: false
      parameter name: :search, in: :query, type: :string, description: 'Search title or content containing the query', required: false
      parameter name: :sort_by, in: :query, type: :string, description: 'Valid value is one of `[id, title, content, created_at, updated_at]`. Default is `created_at`', required: false
      parameter name: :sort_direction, in: :query, type: :string, description: 'Valid value is `asc` or `desc`. Default is `desc`', required: false

      response '200', 'Blog found' do
        schema type: :object,
          properties: {
            data: {
              type: :object,
              properties: {
                items: {
                  type: :array,
                  items: {
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
                pagination: {
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
                }
              },
              required: %w[items pagination]
            },
          },
          required: %w[data]

        let(:id) { Blog.create(title: 'foo', content: 'bar', image: '').id }
        run_test!
      end
    end
  end

  path '/api/v2/blogs/{id}' do
    put 'Update a blog' do
      tags 'Blogs'
      consumes 'multipart/form-data'
      produces 'application/json'
      parameter name: :id, in: :path, type: :number
      parameter name: :blog, in: :body, schema: {
        type: :object,
        properties: {
          'blog[title]': {
            type: :string,
            example: 'My Blog',
            description: 'Title of the blog'
          },
          'blog[content]': {
            type: :string,
            example: 'My Blog Content',
            description: 'Content of the blog'
          },
          'blog[image]': {
            type: :string,
            format: :binary,
            description: 'Image of the blog'
          }
        },
        required: %w[blog[title] blog[content]]
      }

      response '200', 'Blog updated' do
        schema '$ref' => '#/components/schemas/Blog'
        let(:id) { Blog.create(title: 'foo', content: 'bar', image: '').id }
        run_test!
      end

      response '404', 'Blog not found' do
        schema '$ref': '#/components/schemas/Error'
        let(:id) { 'foo' }
        run_test!
      end

      response '422', 'Unprocessable request' do
        schema '$ref': '#/components/schemas/Error'
        let(:id) { Blog.create(title: 'foo', content: 'bar', image: '').id }
        let(:blog) { { blog: { title: 'foo' } } }
        run_test!
      end
    end
  end

  path '/api/v2/blogs/{id}' do
    delete 'Delete a blog' do
      tags 'Blogs'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '204', 'Blog deleted' do
        let(:id) { Blog.create(title: 'foo', content: 'bar', image: '').id }
        run_test!
      end
    end
  end
end
