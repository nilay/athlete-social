class AddDefaultToFlaggingStatus < ActiveRecord::Migration[5.0]
  def change
    change_column :flaggings, :status, :integer, default: 0
  end
end
