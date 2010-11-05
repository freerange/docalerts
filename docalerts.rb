require 'rubygems'
require 'bundler'
Bundler.setup

require 'sinatra'

get '/' do
  "Google-doc-alerts, usage: GET /feed.xml?username=email&password=password"
end