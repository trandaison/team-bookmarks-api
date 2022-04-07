class AddCommentsCountToBlogs < ActiveRecord::Migration[6.1]
  def change
    add_column :blogs, :comments_count, :integer, default: 0, after: :content
  end
end
