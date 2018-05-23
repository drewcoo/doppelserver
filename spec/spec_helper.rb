ENV['RACK_ENV'] = 'test'

require 'coveralls'
Coveralls.wear!

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'doppelserver'

# TODO: Get simplecov report for all code.
require 'simplecov'
SimpleCov.start
