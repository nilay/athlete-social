class AddInvisibleToAthletes < ActiveRecord::Migration[5.0]
  def change
    add_column :athletes, :visible, :boolean, default: true, index: true
  end
end
