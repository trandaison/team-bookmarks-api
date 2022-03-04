# frozen_string_literal: true

require 'swagger_helper'

describe 'Blogs API' do
  path '/api/v1/blogs' do
    post 'Creates a blog' do
      tags 'Blogs'
      consumes 'multipart/form-data'
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
        let(:blog) { { blog: { title: 'foo', content: 'bar' } } }
        run_test!
      end

      response '422', 'Unprocessable entity' do
        let(:blog) { { blog: { title: 'foo' } } }
        run_test!
      end
    end
  end

  path '/api/v1/blogs/{id}' do
    get 'Retrieves a blog by id' do
      tags 'Blogs'
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
        let(:id) { 'invalid' }
        run_test!
      end

      response '406', 'Unsupported accept header' do
        let(:'Accept') { 'application/foo' }
        run_test!
      end
    end
  end

  path '/api/v1/blogs' do
    get 'Retrieves blogs as a list' do
      tags 'Blogs'
      produces 'application/json'
      parameter name: :page, in: :query, type: :number, description: 'Page number. Default is `1`'
      parameter name: :items, in: :query, type: :number, description: 'Number of items per page. Default is `20`'
      parameter name: :search, in: :query, type: :string, description: 'Search title or content containing the query'
      parameter name: :sort_by, in: :query, type: :string, description: 'Valid value is one of `[id, title, content, created_at, updated_at]`. Default is `created_at`'
      parameter name: :sort_direction, in: :query, type: :string, description: 'Valid value is `asc` or `desc`. Default is `desc`'

      response '200', 'Blog found' do
        schema type: :object,
          properties: {
            data: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  title: {
                    type: :string,
                    description: 'Title of the blog'
                  },
                  content: {
                    type: :string,
                    description: 'Content of the blog'
                  },
                  image: {
                    type: :object,
                    description: 'Image of the blog',
                    properties: {
                      url: {
                        type: :string,
                        description: 'Image url'
                      }
                    }
                  },
                  created_at: {
                    type: :string,
                    description: 'Created at of the blog'
                  },
                  updated_at: {
                    type: :string,
                    description: 'Updated at of the blog'
                  }
                }
              }
            },
            pagy: {
              type: :object,
              properties: {
                count: { type: :integer },
                page: { type: :integer },
                items: { type: :integer },
                pages: { type: :integer },
                last: { type: :integer },
                in: { type: :integer },
                from: { type: :integer },
                to: { type: :integer },
                prev: { type: :integer },
                next: { type: :integer }
              }
            }
          },
          required: %w[data pagy]

        let(:id) { Blog.create(title: 'foo', content: 'bar', image: '').id }
        run_test!
      end
    end
  end

  path '/api/v1/blogs/{id}' do
    put 'Update a blog' do
      tags 'Blogs'
      consumes 'multipart/form-data'
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
        let(:id) { Blog.create(title: 'foo', content: 'bar', image: '').id }
        run_test!
      end

      response '404', 'Blog not found' do
        let(:id) { 'foo' }
        run_test!
      end

      response '422', 'Unprocessable request' do
        let(:blog) { { blog: { title: 'foo' } } }
        run_test!
      end
    end
  end

  path '/api/v1/blogs/{id}' do
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
