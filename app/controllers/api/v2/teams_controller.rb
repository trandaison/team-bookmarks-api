class Api::V2::TeamsController < Api::V2::BaseController
  def index
    pagy_info, teams = pagy(current_user.teams, items: params[:offset])
    render json: as_json_list(ActiveModel::Serializer::CollectionSerializer.new(teams), pagy_info)
  end

  def create
    team = Team.new(team_params)
    if team.save
      team.team_users.create(team_user_params)
      render json: team, status: :created
    else
      render json: { errors: team.errors_details }, status: :unprocessable_entity
    end
  end

  def show
    team = current_user.teams.includes(:folders, :bookmarks).find(params[:id])
    render json: team, serializer: TeamDetailSerializer
  end

  protected

  def team_params
    params.require(:team).permit(:name, :icon, :description)
  end

  def team_user_params
    {
      user: current_user,
      role: TeamUser.roles[:owner],
      invited_by_id: current_user.id,
      active: true
    }
  end
end
