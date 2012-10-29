# -*- encoding: utf-8 -*-
require File.expand_path('./lib/uboost-client/version')

Gem::Specification.new do |gem|
  gem.authors       = ["Gonzalo Rodríguez-Baltanás Díaz"]
  gem.email         = ["siotopo@gmail.com"]
  gem.description   = %q{uBoost ruby client}
  gem.homepage      = "https://github.com/haikulearning/uboost-client"
  gem.summary       = gem.description

  gem.name          = "uboost-client"
  gem.require_paths = ["lib"]
  gem.files         = `git ls-files`.split("\n")
  gem.version       = UboostClient::VERSION

  gem.add_dependency "faraday"
  gem.add_development_dependency "bundler", ">= 1.0"
  gem.add_development_dependency "rake"
end
