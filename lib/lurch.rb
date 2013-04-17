require 'bundler/setup'
Bundler.require

require_relative 'lurch/lurch'
require_relative 'lurch/connection'

EventMachine.run do
  LURCH = Lurch.new
  LURCH.start
end
