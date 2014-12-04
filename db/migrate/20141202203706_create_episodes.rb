class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.datetime :published_at
      t.string :title, null: false
      t.text :description
      t.integer :duration
      t.integer :vimeo_id
      t.string :hd_video_url
      t.string :hd_content_type
      t.integer :hd_file_size
      t.string :hd_poster_url
      t.string :sd_video_url
      t.string :sd_content_type
      t.integer :sd_file_size
      t.string :sd_poster_url

      t.timestamps
    end

    add_index :episodes, :published_at
  end
end
