require 'bundler/setup'
Bundler.require

DB = Sequel.connect('sqlite://lurch.db')

DB.create_table? :rules do
  primary_key [:handler, :pattern]
  String :handler
  String :pattern
  Float :popularity
  DateTime :last_accessed
end

require_relative 'lurch/server'
require_relative 'lurch/handler'

Dir[File.join(Dir.pwd, 'lib', 'lurch', 'handlers', '*.rb')].each { |handler| require handler }

EventMachine.run do
  LURCH = Lurch::Server.new
  LURCH.start
end
