
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "CartBinaryUploader/version"

Gem::Specification.new do |spec|
  spec.name          = "cartup"
  spec.version       = CartBinaryUploader::VERSION
  spec.authors       = ["Douglas Mendes", "Rafael Ferreria"]
  spec.email         = ["mendes-barreto@live.com", "rafael.yami@hotmail.com"]

  spec.summary       = %q{ This gem will help you to upload the carthage binaries a privates accounts like google cloud, s3 e etc. }
  spec.description   = <<-EOF
    Cartup is the easyest way to share prebuilts Carthage frameworks between our projects.

    The main propose of this gem is uploading the Carthage prebuilts to a cloud
    storage like, drive, onedrive, dropbox or google cloud. To know more how to make prebuilts with Carthage please follow
    the link about how to do it: https://github.com/Carthage/Carthage#archive-prebuilt-frameworks-into-one-zip-file

    Currently, the main problem is because only github projects could upload a prebuilts frameworks and distrubuite
    them using a great github tool called "RELEASES"(https://help.github.com/articles/creating-releases/) automatically.
    To people like me who the majority of our clients using Bitbucket the all process should be done manually. So you should
    upload the prebuilts frameworks on some sort of cloud storage and manage the version using a JSON file and upload
    manually and because that the gem was born! To the people like me who are a bit lazy and do not like to do manual job,
    this is for you!!!

    So, in a head line: Our gem wants to make the process of distribution of prebuild carthage binaries easier through the
    most popular storage cloud.

    One big thanks for my friend and brother [Rafael Ferreira](https://github.com/RafaelPlantard) that make the initials
    scripts(Shell and Ruby) and that's give me Ideia to bring it to a ruby class struct and RubyGem to distribute to every body!
  EOF

  spec.homepage      = "https://github.com/mendesbarreto/cartup.git"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = ["cartup"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'google-cloud-storage', '~> 1.9'
  spec.add_development_dependency 'json', '~> 2.1'
end
