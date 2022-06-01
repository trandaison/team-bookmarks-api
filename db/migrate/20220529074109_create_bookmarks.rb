class CreateBookmarks < ActiveRecord::Migration[6.1]
  def change
    create_table :bookmarks do |t|
      t.references :team, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :sharing_mode, default: 0
      t.integer :position
      t.integer :bookmark_type, default: 0
      t.text :content
      t.string :name
      t.bigint :folder_id

      t.timestamps
    end
  end
end
