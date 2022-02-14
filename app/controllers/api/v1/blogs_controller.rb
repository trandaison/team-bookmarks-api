class Api::V1::BlogsController < ApplicationController
  before_action :set_blog, only: [:show, :update, :destroy]

  # GET /api/v1/blogs
  def index
    @q = Blog.order(created_at: :desc).ransack(search_query)
    @pagy, @blogs = pagy(@q.result, items: params[:items])

    render json: { data: @blogs, pagy: pagy_meta(@pagy) }
  end

  # GET /api/v1/blogs/1
  def show
    render json: @blog
  end

  # POST /api/v1/blogs
  def create
    @blog = Blog.new(blog_params)

    if @blog.save
      render json: @blog, status: :created
    else
      render json: @blog.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/blogs/1
  def update
    if @blog.update(blog_params)
      render json: @blog
    else
      render json: @blog.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/blogs/1
  def destroy
    @blog.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_blog
    @blog = Blog.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def blog_params
    params.require(:blog).permit(:title, :content, :image)
  end

  def search_query
    {
      title_or_content_cont: params[:search],
      s: "#{params[:sort_by]} #{params[:sort_direction]}"
    }
  end
end
