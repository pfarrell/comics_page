root = ::File.dirname(__FILE__)
require ::File.join(root, 'app')

set :environment, ENV['RACK_ENV'].to_sym
disable :run, :reload

run Comics.new
