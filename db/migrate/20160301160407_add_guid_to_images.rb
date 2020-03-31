class AddGuidToImages < ActiveRecord::Migration[5.0]
  def change
    add_column :images, :guid, :string
  end
end
