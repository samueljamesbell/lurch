require 'bundler/setup'
Bundler.require

DB = Sequel.connect('sqlite://' + File.join(Dir.pwd, 'lurch.db'))

DB.create_table? :rules do
  primary_key [:handler, :pattern]
  String :handler
  String :pattern
  Integer :rank
  DateTime :last_accessed
end

DB.create_table? :users do
  primary_key :email
  String :email
  String :name
end

require_relative 'lurch/server'
require_relative 'lurch/dispatch'
require_relative 'lurch/handler'

Dir[File.join(Dir.pwd, 'lib', 'lurch', 'handlers', '*.rb')].each { |handler| require handler }
