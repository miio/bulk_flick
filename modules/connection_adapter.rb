module BulkFlick
  class ConnectionAdapter
    def connection
      FlickRaw.api_key = CONFIG['api']['api_key']
      FlickRaw.shared_secret = CONFIG['api']['shared_secret']
      flickr.access_token = CONFIG['api']['access_token']
      flickr.access_secret = CONFIG['api']['access_secret']
      flickr
    end
  end
end

