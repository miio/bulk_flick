module BulkFlick
  class Uploader
    def self.execute d, root, f, ext
      begin
        p "checking #{f}"
        if d.duplicate? root, f.sub(/\.#{ext}/,''), ".#{ext}"
          p "Uploaded #{f} Skip this..."
          return d.get_remote_by_exif root, f.sub(/\.#{ext}/,''), ".#{ext}"
        else
          p "begin upload #{f} ..."
          pid = d.flickr.upload_photo "#{root}/#{f}", title: f.sub(/\.#{ext}/, '')
          p "uploaded #{f}"
          return pid
        end
      rescue => e
        p "Retry... #{f}, Error: #{e}"
        self.execute d, root, f, ext
      end
    end

    def self.createSets d, pid, name
      sets = d.flickr.photosets.create title: name ,primary_photo_id: pid
      sets.id
    end

    def self.addSets d, pid, sid
      d.flickr.photosets.addPhoto photoset_id: sid ,photo_id: pid
      true
    end
  end
end
