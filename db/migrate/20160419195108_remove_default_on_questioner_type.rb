class RemoveDefaultOnQuestionerType < ActiveRecord::Migration[5.0]
  def change
    change_column :questions, :questioner_type, :integer, default: nil
  end
end
