require 'bundler/setup'
Bundler.require

require_relative 'lurch/server'
require_relative 'lurch/handler'

# Should auto-require all handlers here

DB = Sequel.connect('sqlite://lurch.db')

DB.create_table? :rules do
  primary_key [:handler, :pattern]
  String :handler
  String :pattern
  Float :popularity
  DateTime :last_accessed
end

EventMachine.run do
  LURCH = Lurch::Server.new
  LURCH.start
end
