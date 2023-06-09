Gem::Specification.new do |s|
  s.name          = 'logstash-output-elasticapm'
  s.version       = '0.2.0'
  s.licenses      = ['Apache-2.0']
  s.summary       = 'Logstash output plugin for Elastic APM'
  s.description   = 'Logstash output plugin to send traces and metrics to Elastic APM Server'
  s.homepage      = 'https://github.com/yesmarket/logstash-output-elasticapm'
  s.authors       = ['Ryan Bartsch']
  s.email         = 'rbartsch@yandex.com'
  s.require_paths = ['lib']

  # Files
  s.files = Dir['lib/**/*','spec/**/*','vendor/**/*','*.gemspec','*.md','CONTRIBUTORS','Gemfile','LICENSE','NOTICE.TXT']
   # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "output" }

  # Gem dependencies
  s.add_runtime_dependency "rest-client", "~> 2.1"
  s.add_runtime_dependency "jsonpath", "~> 1.1"
  s.add_runtime_dependency "logstash-core-plugin-api", "~> 2.0"
  s.add_runtime_dependency "logstash-codec-plain"
  s.add_development_dependency "logstash-devutils"
end
