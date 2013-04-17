require 'bundler/setup'
Bundler.require

require_relative 'lurch/server'
require_relative 'lurch/connection'

EventMachine.run do
  LURCH = Lurch::Server.new
  LURCH.start
end
