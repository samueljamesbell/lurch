require 'bundler/setup'
Bundler.require

DB = Sequel.connect('sqlite://lurch.db')

DB.create_table? :rules do
  primary_key [:handler, :pattern]
  String :handler
  String :pattern
  Integer :rank
  DateTime :last_accessed
end

require_relative 'lurch/server'
require_relative 'lurch/handler'

Dir[File.join(Dir.pwd, 'lib', 'lurch', 'handlers', '*.rb')].each { |handler| require handler }

EventMachine.run do
  server = Lurch::Server.new
  server.start
end
