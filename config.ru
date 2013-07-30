require 'rubygems'
require 'bundler/setup'
require 'imagist'

map '/' do
  run Imagist::App
end
