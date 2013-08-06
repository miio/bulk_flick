require "#{File.expand_path(File.dirname(__FILE__))}/modules/module"
require "sinatra"

get '/' do
  d = BulkFlick::Duplicator.new
  @sets = d.flickr.photosets.getList.to_a
  Dir.chdir(File.expand_path(File.dirname(__FILE__))) do
    slim :index
  end
end

get '/uploads/current_state' do
  "#{BulkFlick::UploadQueue.instance.current_state_json}"
end

post '/uploads/add_queue' do
  EM::defer do
    q = BulkFlick::UploadQueue.instance
    q.reset_queue_count if q.current_state >= 100
    q.upload params[:root], params[:sets_id], params[:name]
  end
  redirect '/'
end
