class AddSharingModeToFolder < ActiveRecord::Migration[6.1]
  def change
    add_column :folders, :sharing_mode, :integer, default: 0
  end
end
