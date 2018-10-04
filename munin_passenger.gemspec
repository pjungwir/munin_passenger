lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'munin_passenger/version'

Gem::Specification.new do |s|
  s.name     = "munin_passenger"
  s.version  = MuninPassenger::VERSION
  s.platform = Gem::Platform::RUBY

  s.summary     = "Munin plugin for monitoring Phusion Passenger."
  s.description = "Runs passenger-status to graph CPU, RAM, queue size, requests served, etc."

  s.authors  = ["Paul A. Jungwirth"]
  s.homepage = "https://github.com/pjungwir/munin_passenger"
  s.email    = "pj@illuminatedcomputing.com"

  s.licenses = ["MIT"]

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,fixtures}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{|f| File.basename(f)}.reject{|f| f =~ /\.sh$/}
  s.require_paths = ["lib"]
  s.rdoc_options  = ['--charset=UTF-8']

  s.add_development_dependency 'rake'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'timecop'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'rubocop'

  s.add_dependency 'nokogiri'
  s.add_dependency 'json'
end

