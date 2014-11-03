$: << File.expand_path('../app', __FILE__)

require 'sinatra'
require 'sinatra/url_for'
require 'date'
require 'haml'
require 'yaml'


class Comics < Sinatra::Application
  helpers Sinatra::UrlForHelper

  set :haml =>{:format => :html5}

  $config = YAML.load_file 'config/config.yml'

  def get_files(search_path, dest_path)
    ret=[]
    Dir.foreach(search_path) do |f|
      ret.push("comics/#{dest_path}/#{f}") unless f == "." || f==".."
    end
    ret
  end

  get '/' do
    redirect url_for "/#{Date.today.to_s}"
  end

  get '/favicon.ico' do
    "hello"
  end

  get '/:date' do
    @date = Date.parse(params['date'])
    @title = "Comics for #{@date.to_s}"
    @files = get_files("#{$config["dest_dir"]}/#{@date.to_s}", @date.to_s)
    haml :index
  end
end

