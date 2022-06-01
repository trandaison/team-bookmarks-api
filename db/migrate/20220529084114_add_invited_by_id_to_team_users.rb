class AddInvitedByIdToTeamUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :team_users, :invited_by_id, :integer
  end
end
