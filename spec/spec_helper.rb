require 'coveralls'
Coveralls.wear!

# TODO: Get simplecov report for all code.
require 'simplecov'
SimpleCov.start

require 'json'
require 'rspec'

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'doppelserver'

# Used in service_controller_spec and command_line_spec:
DEFAULT_DATA = { 'data' => {}, 'next_keys' => {} }.to_json
TEST_DATA = { 'data' => { 'things' => { '0' => { 'name' => 'first' } } },
              'next_keys' => { 'things' => 1 } }.to_json

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.fail_fast = 1
  config.profile_examples = true
  config.order = :random
end
