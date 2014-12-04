class Episode < ActiveRecord::Base
  def self.create_with_vimeo_id(vimeo_id)
    require 'mechanize'

    response = Mechanize.new.get "https://api.vimeo.com/videos/#{vimeo_id}?access_token=#{VIMEO_ACCESS_TOKEN}"
    json = JSON(response.body)

    sd = json['files'].select { |f| f['quality'] == 'sd' }.first
    hd = json['files'].select { |f| f['quality'] == 'hd' }.first

    Episode.create(
      title: json['name'],
      description: json['description'],
      vimeo_id: vimeo_id.to_i,
      duration: json['duration'],
      published_at: DateTime.parse(json['created_time']),
      sd_video_url: sd['link_secure'],
      sd_content_type: sd['type'],
      sd_file_size: Mechanize.new.head(sd['link_secure'])['content-length'].to_i,
      sd_poster_url: "https://i.vimeocdn.com/video/#{vimeo_id}_640x360.jpg",
      hd_video_url: hd['link_secure'],
      hd_content_type: hd['type'],
      hd_file_size: Mechanize.new.head(hd['link_secure'])['content-length'].to_i,
      hd_poster_url: "https://i.vimeocdn.com/video/#{vimeo_id}_1280x720.jpg",
    )
  end

  def subtitle
    description
  end

  def description_html
    Twitter::Autolink.auto_link description
  end

  def slug
    published_at.strftime('%Y-%m-%d')
  end

  def video_url(type)
    type == :sd ? sd_video_url : hd_video_url
  end

  def content_type(type)
    type == :sd ? sd_content_type : hd_content_type
  end

  def file_size(type)
    type == :sd ? sd_file_size : hd_file_size
  end

  def poster_url(type)
    type == :sd ? sd_poster_url : hd_poster_url
  end
end
