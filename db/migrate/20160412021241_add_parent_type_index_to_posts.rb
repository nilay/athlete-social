class AddParentTypeIndexToPosts < ActiveRecord::Migration[5.0]
  def change
    remove_index :posts, :parent_id
    add_index :posts, [:parent_id, :parent_type]
    add_index :questions, [:questioner_id, :questioner_type]
  end
end
