class Api::V2::FoldersController < Api::V2::BaseController
  before_action :set_team, only: :create
  before_action :set_folder, except: :create

  def create
    folder = @team.folders.create(folder_params)
    render json: folder
  end

  def show
    render json: @folder
  end

  def update
    @folder.update(update_folder_params)
    if @folder.save
      render json: @folder
    else
      render json: @folder.errors_details, status: :unprocessable_entity
    end
  end

  def destroy
    @folder.destroy
  end

  protected

  def set_team
    @team = current_user.teams.find(params[:team_id])
  end

  def set_folder
    @folder = current_user.folders.find(params[:id])
  end

  def folder_params
    permited_params = params.require(:folder).permit(:name, :icon, :parent_id, :sharing_mode)
    permited_params.merge!(user_id: current_user.id)
  end

  def update_folder_params
    params.require(:folder).permit(:name, :icon, :parent_id, :sharing_mode, :position)
  end
end
