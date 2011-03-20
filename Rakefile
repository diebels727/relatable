require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('relatable', '0.0.1') do |p|
  p.description    = "Emulate a triple store."
  p.url            = "http://github.com/jquigg/relatable"
  p.author         = "Jonathan Quigg"
  p.email          = "diebels727@hotmail.com"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
