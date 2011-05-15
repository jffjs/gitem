require 'bundler/setup'
require 'webmock/rspec'
require 'gitem'

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file)
  File.open(fixture_path + '/' + file)
end
