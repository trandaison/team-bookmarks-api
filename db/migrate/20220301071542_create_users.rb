class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email, index: { unique: true }
      t.string :password_digest
      t.string :name
      t.string :avatar
      t.boolean :admin, default: false

      t.timestamps
    end
  end
end
