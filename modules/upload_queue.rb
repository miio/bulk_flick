module BulkFlick
  class UploadQueue
    include Singleton

    def initialize
      @@queue_max = 0
      @@queue_current = 0
      @@sets_id = nil
    end

    def upload root, sets_id, name
      @@sets_id = sets_id
      pids = []
      d = Duplicator.new
      dir = nil
      ext = "jpg"
      Dir.chdir( root ) do
        dir = Dir.glob("*.#{ext}")
      end
      @@queue_max += dir.length
      p dir.length
      Parallel.each(dir, in_threads: 40) do |f|
        p f
        pids << Uploader::execute(d, root, f, ext)
        @@queue_current += 1
      end
      unless pids.empty?
        if @@sets_id.empty?
          @@sets_id = Uploader::createSets d, pids.first, name
          pids.delete_at 0
        end
        pids.each do |pid|
          begin
            Uploader::addSets d, pid, @@sets_id
            puts "added #{pid}"
          rescue
            # "already in set"
          end
        end
      end
    end

    def reset_queue_count
      @@queue_max = 0
      @@queue_current = 0
    end

    def current_state_json
      {rate: self.current_state}.to_json
    end

    def current_state
      return 100 * @@queue_current.to_f/@@queue_max.to_f if @@queue_max > 0
      0
    end
  end
end
