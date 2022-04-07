class Api::V2::CommentsController < Api::V2::BaseController
  skip_before_action :authorized, only: %i[show index]
  before_action :set_blog, only: %i[index create]
  before_action :set_comment, only: %i[update destroy]

  def index
    sort_direction = params[:sort_direction] == 'asc' ? :asc : :desc
    @comments = @blog.comments
                     .includes(:user)
                     .infinite_load(cursor_id: params[:cursor_id].presence, items: params[:offset], direction: sort_direction)

    render json: as_json_list(@comments.as_json(
      include: {
        user: { only: %i[id email name avatar] } },
        except: :user_id
    ))
  end

  def create
    @comment = @blog.comments.new(comment_params.merge!(user_id: current_user.id))

    if @comment.save
      render json: as_json(@comment.as_json), status: :created
    else
      render json: as_json_error(@comment.errors_details), status: :unprocessable_entity
    end
  end

  def show
    @comment = Comment.find(params[:id])
    render json: as_json(@comment)
  end

  def update
    if @comment.update(comment_params)
      render json: as_json(@comment.as_json), status: :ok
    else
      render json: as_json_error(@comment.errors_details), status: :unprocessable_entity
    end
  end

  def destroy
    @comment.soft_destroy unless @comment.deleted_at?
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def set_blog
    @blog = Blog.find(params[:blog_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
    raise ForbiddenError unless current_user.admin? || current_user.id == @comment.user_id
  end
end
