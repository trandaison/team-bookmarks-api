class Api::V2::BlogsController < Api::V2::UnauthorizedController
  before_action :set_blog, only: [:show, :update, :destroy]

  def index
    @q = Blog.order(created_at: :desc).ransack(search_query)
    @pagy, @blogs = pagy(@q.result, items: params[:offset])

    render json: as_json_list(@blogs, @pagy)
  end

  def show
    render json: as_json(@blog)
  end

  def create
    @blog = Blog.new(blog_params)

    if @blog.save
      render json: as_json(@blog.reload), status: :created
    else
      render json: as_json_error(@blog.errors_details), status: :unprocessable_entity
    end
  end

  def update
    if @blog.update(blog_params)
      render json: as_json(@blog.reload)
    else
      render json: as_json_error(@blog.errors_details), status: :unprocessable_entity
    end
  end

  def destroy
    @blog.destroy
  end

  private
  def set_blog
    @blog = Blog.find(params[:id])
  end

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
