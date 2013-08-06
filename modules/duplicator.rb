module BulkFlick
  class Duplicator

    def initialize
      @adapter = ConnectionAdapter.new
      @flickr = @adapter.connection
      @user = @flickr.test.login
    end

    def search_by_filename filename
      @flickr.photos.search user_id: @user.id, text: filename
    end

    def get_remote_by_exif dir, to_filename, ext, from_file = nil
      puts "#{dir}/#{to_filename}"
      target = self.search_by_filename to_filename
      target.each do |e|
        flickr_date_time = self.parse_time(@flickr.photos.getExif(photo_id: e.id).exif.to_a.select{|e| e.tag == 'DateTimeOriginal'}.first.raw)
        local_date_time = self.parse_time(EXIFR::JPEG::new("#{dir}/#{to_filename}#{ext}").date_time)
        return e.id if flickr_date_time == local_date_time
      end
      nil
    end

    def duplicate? dir, to_filename, ext, from_file = nil
      return true unless self.get_remote_by_exif(dir, to_filename, ext, from_file).nil?
      false
    end

    def parse_time time
      # http://blog.hacklife.net/archives/51297712.html
      time = time.to_s.gsub(/\-/, '/')
      t = time.split(/[\/ :.]/)[0..5]
      Time.utc(*t)
    end

    def flickr
      @flickr
    end
  end
end

