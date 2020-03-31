class AddFieldsToVideos < ActiveRecord::Migration[5.0]
  def change
    add_column :videos, :panda_video_id, :string
    add_column :videos, :guid, :string
    add_column :videos, :profiles, :json
  end
end
