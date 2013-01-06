require 'sinatra'
require 'date'
require 'haml'

set :port, 4579
set :haml =>{:format => :html5}

$config = YAML.load_file 'config/config.yml'

def get_files(search_path, dest_path)
  ret=[]
  Dir.foreach(search_path) do |f|
    ret.push("#{dest_path}/#{f}") unless f == "." || f==".."
  end
  ret
end

get '/' do
  redirect "/#{Date.today.to_s}"
end

get '/favicon.ico' do
  "hello"
end

get '/:date' do
  p "#{params['date']}"
  @date = Date.parse(params['date'])
  @title = "Comics for #{@date.to_s}"
  @files = get_files("#{$config["dest_dir"]}/#{@date.to_s}", @date.to_s)
  p @files.inspect
  haml :index
end


