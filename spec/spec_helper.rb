require 'simplecov'
SimpleCov.start do
  add_filter %r{^/spec/}
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'rspec/matchers'
require 'munin_passenger'
require 'timecop'

RSpec.configure do |config|

end
