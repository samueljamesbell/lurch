require 'bundler/setup'
Bundler.require

require_relative 'lurch/server'

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
