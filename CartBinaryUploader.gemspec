
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "CartBinaryUploader/version"

Gem::Specification.new do |spec|
  spec.name          = "CartBinaryUploader"
  spec.version       = CartBinaryUploader::VERSION
  spec.authors       = ["Douglas Mendes", "Rafael Ferreria"]
  spec.email         = ["mendes-barreto@live.com", "rafael.yami@hotmail.com"]

  spec.summary       = %q{This gem will do some thing important}
  spec.description   = %q{And after all will input some here to do}
  spec.homepage      = "https://github.com/mendesbarreto/CartBinaryUploader.git"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'google-cloud-storage', '~> 1.9'
  spec.add_development_dependency 'json', '~> 2.1'
end
