class CreateTeamUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :team_users do |t|
      t.references :team, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :role
      t.references :invited_by, null: false, foreign_key: true
      t.boolean :active, default: false

      t.timestamps
    end
  end
end
