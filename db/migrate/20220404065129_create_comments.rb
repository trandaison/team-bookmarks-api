class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.bigint :user_id
      t.references :blog, null: false, foreign_key: true
      t.text :content
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :comments, :user_id
    add_index :comments, :deleted_at
  end
end
