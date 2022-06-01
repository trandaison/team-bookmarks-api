class CreateTeams < ActiveRecord::Migration[6.1]
  def change
    create_table :teams do |t|
      t.string :name
      t.string :icon
      t.string :description
      t.boolean :pinned, default: false
      t.integer :position

      t.timestamps
    end
  end
end
