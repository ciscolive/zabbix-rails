require_relative "lib/zabbix/version"

Gem::Specification.new do |spec|
  spec.name        = "zabbix-rails"
  spec.version     = Zabbix::VERSION
  spec.authors     = ["WENWU.YAN"]
  spec.email       = ["careline@foxmail.com"]
  spec.homepage    = "https://rubygem.org"
  spec.summary     = "Summary of Zabbix-rails."
  spec.description = "Description of Zabbix-rails."

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "https://rubygem.org"

  spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails"
end
