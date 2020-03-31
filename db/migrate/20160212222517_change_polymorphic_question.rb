class ChangePolymorphicQuestion < ActiveRecord::Migration[5.0]
  def change
    remove_column :questions, :questionable_id
    remove_column :questions, :questionable_type
    add_column :questions, :questioner_id, :integer
    add_column :questions, :questioner_type, :integer, default: 1
  end
end
