require 'rubygems'
require 'sinatra'
gem 'emk-sinatra-url-for'
require 'sinatra/url_for'

set :environment, ENV['RACK_ENV'].to_sym
disable :run, :reload

require './comics'

run Sinatra::Application
