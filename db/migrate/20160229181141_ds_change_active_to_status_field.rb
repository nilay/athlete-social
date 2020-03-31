class DsChangeActiveToStatusField < ActiveRecord::Migration[5.0]
  def change
    remove_column :questions, :active
    add_column :questions, :status, :integer, default: 0
  end
end
