%w[
  flickraw
  open-uri
  exifr
  parallel
  slim
  singleton
  json
  yaml
].each do |m|
  require m
end

module BulkFlick
  CONFIG = YAML.load_file "#{File.expand_path(File.dirname(__FILE__))}/../config.yml"
end

%w[
  authorization
  connection_adapter
  duplicator
  uploader
  upload_queue
].each do |m|
  require "#{File.expand_path(File.dirname(__FILE__))}/#{m}"
end

