# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'goggles/version'

Gem::Specification.new do |spec|
  spec.name          = "goggles"
  spec.version       = Goggles::VERSION
  spec.authors       = ["Johnson Denen"]
  spec.email         = ["johnson.denen@gmail.com"]
  spec.summary       = %q{Compare screenshots in different browsers at different sizes}
  spec.description   = %q{Compare screenshots in different browsers at different sizes}
  spec.homepage      = "http://github.com/jdenen/goggles"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "cucumber"

  spec.add_runtime_dependency "watir-webdriver"
  spec.add_runtime_dependency "image_size"
end
