class CreateQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :questions do |t|
      t.text :text
      t.integer :questionable_id
      t.string :questionable_type
      t.boolean :sponsored
      t.timestamps
    end
  end
end
