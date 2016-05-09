require 'mongoid'
require 'mongoid-filterable'

Mongoid.load!("spec/support/mongoid.yml", :test)

Mongoid.logger.level = Logger::ERROR
Mongo::Logger.logger.level = Logger::ERROR
