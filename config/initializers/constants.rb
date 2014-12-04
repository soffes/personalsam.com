%w{VIMEO_ACCESS_TOKEN MIXPANEL_TOKEN DOWNLOAD_SHARED_SECRET}.each do |key|
  raise "Required environment variable `#{key}` is missing." unless value = ENV[key]
  Kernel.const_set key, value
end
