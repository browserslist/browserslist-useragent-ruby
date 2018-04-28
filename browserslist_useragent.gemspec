
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'browserslist_useragent/version'

Gem::Specification.new do |spec|
  spec.name          = 'browserslist_useragent'
  spec.version       = BrowserslistUseragent::VERSION
  spec.authors       = ['Salahutdinov Dmitry']
  spec.email         = ['dsalahutdinov@gmail.com']

  spec.summary       = 'Find if a given user agent string satisfies a browserslist query.'
  spec.description   = 'Gem provides easy way to match browser user agent string with specified set of rules (from browserslist tool)'
  spec.homepage      = 'https://github.com/dsalahutdinov/browserlist-useragent-ruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'semantic'
  spec.add_runtime_dependency 'user_agent_parser'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.55'
end
