class PolymorphizePosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :parent_type, :string, index: true, default: 'Post'
  end
end
