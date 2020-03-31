class AddRankToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :rank, :decimal, default: 0.0
    add_index :posts, :rank, order: { rank: "DESC NULLS LAST" }
  end
end
