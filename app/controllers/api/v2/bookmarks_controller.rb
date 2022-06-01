class Api::V2::BookmarksController < Api::V2::BaseController
  before_action :set_team, only: :create
  before_action :set_folder, only: %i[create update]
  before_action :set_bookmark, except: :create

  def create
    bookmark = @team.bookmarks.create(bookmark_params)
    render json: bookmark
  end

  def show
    render json: @bookmark
  end

  def update
    @bookmark.update(update_bookmark_params)
    if @bookmark.save
      render json: @bookmark
    else
      render json: @bookmark.errors_details, status: :unprocessable_entity
    end
  end

  def destroy
    @bookmark.destroy
  end

  protected

  def set_team
    @team = current_user.teams.find(params[:team_id])
  end

  def set_bookmark
    @bookmark = @team.bookmarks.find(params[:id])
  end

  def bookmark_params
    permited_params = params.require(:bookmark).permit(:name, :content, :sharing_mode, :bookmark_type)
    permited_params.merge!(user_id: current_user.id, folder_id: @folder&.id)
  end

  def update_bookmark_params
    params.require(:bookmark).permit(:name, :content, :folder_id, :sharing_mode, :position)
  end

  def set_folder
    folder_id = params.dig(:bookmark, :folder_id)
    @folder = if folder_id
                @team.folders.find(folder_id)
              elsif params[:folder]
                @team.folders.create(folder_params)
              end
  end

  def folder_params
    permited_params = params.require(:folder).permit(:name, :icon, :parent_id, :sharing_mode)
    permited_params.merge!(user_id: current_user.id)
  end
end
