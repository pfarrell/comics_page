require 'sinatra'
require 'date'
require 'haml'


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
  haml :index
end


