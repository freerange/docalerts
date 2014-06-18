require 'rubygems'
require 'bundler'
Bundler.setup

require_relative 'docalerts'
require 'rack-ssl-enforcer'

use Rack::SslEnforcer

disable :logging

run Sinatra::Application