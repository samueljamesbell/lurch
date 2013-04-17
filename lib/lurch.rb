require 'bundler/setup'
Bundler.require

require_relative 'lurch/server'

EventMachine.run do
  LURCH = Lurch::Server.new
  LURCH.start
end
