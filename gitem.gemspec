# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "gitem/version"

Gem::Specification.new do |s|
  s.name        = "gitem"
  s.version     = Gitem::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jeff Smith"]
  s.email       = ["jffreyjs@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Grab and update all of your watched Github repos with one command.}
  s.description = %q{Grab and update all of your watched Github repos with one command.}

  s.rubyforge_project = "gitem"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency %q<rspec>, ['~> 2.0.0.beta.22']
      s.add_development_dependency %q<webmock>, ['~> 1.6.2']
      s.add_dependency %q<thor>, ['~> 0.14.6']
      s.add_dependency %q<httparty>, ['~> 0.7.4']
    else
      s.add_dependency %q<rspec>, ['~> 2.0.0.beta.22']
      s.add_dependency %q<webmock>, ['~> 1.6.2']
      s.add_dependency %q<thor>, ['~> 0.14.6']
      s.add_dependency %q<httparty>, ['~> 0.7.4']
    end
  else
    s.add_dependency %q<rspec>, ['~> 2.0.0.beta.22']
    s.add_dependency %q<webmock>, ['~> 1.6.2']
    s.add_dependency %q<thor>, ['~> 0.14.6']
    s.add_dependency %q<httparty>, ['~> 0.7.4']
  end
end
