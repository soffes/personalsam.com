require 'digest/sha1'
require 'mechanize'

class Episode < ActiveRecord::Base
  def self.create_with_vimeo_id(vimeo_id)
    raise 'Missing vimeo_id' unless vimeo_id
    episode = Episode.new(vimeo_id: vimeo_id)
    episode.update
    episode.save
    episode
  end

  def to_param
    slug
  end

  def subtitle
    description[0...255]
  end

  def description_html
    return nil unless description
    Twitter::Autolink.auto_link(description).gsub("\n", '<br>')
  end

  def video_url(type=:hd, secure=false)
    url = type == :sd ? sd_video_url : hd_video_url
    url = url.sub('https://', 'http://') unless secure
    signature = Digest::SHA1.hexdigest DOWNLOAD_SHARED_SECRET + url + slug + type.to_s
    "http://download.personalsam.com/video#{Addressable::URI.parse(url).extname}?url=#{CGI::escape url}&slug=#{slug}&type=#{type}&signature=#{signature}"
  end

  def content_type(type=:hd)
    type == :sd ? sd_content_type : hd_content_type
  end

  def file_size(type=:hd)
    type == :sd ? sd_file_size : hd_file_size
  end

  def poster_url(type=:hd, secure=false)
    url = type == :sd ? sd_poster_url : hd_poster_url
    url = url.sub('https://', 'http://') unless secure
    url
  end

  def extension(type=:hd)
    Addressable::URI.parse(video_url(type)).extname.sub('.', '')
  end

  def update
    response = Mechanize.new.get "https://api.vimeo.com/videos/#{vimeo_id}?access_token=#{VIMEO_ACCESS_TOKEN}"
    json = JSON(response.body)

    sd = json['files'].select { |f| f['quality'] == 'sd' }.first
    hd = json['files'].select { |f| f['quality'] == 'hd' }.first
    poster_id = (json['pictures']['sizes'].first)['link'].match(/https:\/\/i\.vimeocdn\.com\/video\/([0-9]+)_/)[1]
    published_at = DateTime.parse(json['created_time'])
    slug = json['name'].match(/([0-9]{4}-[0-9]{2}-[0-9]{2})/)[1]
    raise 'Missing slug' unless slug

    self.title = json['name']
    self.description = json['description']
    self.vimeo_id = vimeo_id.to_i
    self.duration = json['duration']
    self.published_at = published_at
    self.slug = slug
    self.sd_video_url = sd['link_secure']
    self.sd_content_type = sd['type']
    self.sd_file_size = Mechanize.new.head(sd['link_secure'])['content-length'].to_i
    self.sd_poster_url = "https://i.vimeocdn.com/video/#{poster_id}_640x360.jpg"
    self.hd_video_url = hd['link_secure']
    self.hd_content_type = hd['type']
    self.hd_file_size = Mechanize.new.head(hd['link_secure'])['content-length'].to_i
    self.hd_poster_url = "https://i.vimeocdn.com/video/#{poster_id}_1280x720.jpg"
    json
  end
end
