class AddShareCountToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :share_count, :integer,  default: 0
  end
end
