# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-buffer-pullpool"
  spec.version       = "0.0.1"
  spec.authors       = ["TAGOMORI Satoshi"]
  spec.email         = ["tagomoris@gmail.com"]
  spec.summary       = %q{Fluentd file buffer plugin to buffer data for pullers}
  spec.description   = %q{Alternative file buffer plugin to store data to wait to be pulled by plugin}
  spec.homepage      = "https://github.com/tagomoris/fluent-plugin-buffer-pullpool"
  spec.license       = "APLv2"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency "fluentd"
end
