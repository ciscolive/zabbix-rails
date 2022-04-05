# frozen_string_literal: true

require_relative "lib/zabbix/version"

Gem::Specification.new do |spec|
  spec.name        = "zabbix-rails"
  spec.version     = Zabbix::VERSION
  spec.authors     = ["WENWU.YAN"]
  spec.email       = ["careline@foxmail.com"]
  spec.homepage    = "https://github.com/ciscolive/zabbix-rails"
  spec.summary     = "主要实现 zabbix_connector 对象缓存，加速 API 交互效率"
  spec.description = "借助 zabbix_manager 实现自动维护 zabbix 监控对象"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "https://rubygem.org"

  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ciscolive/zabbix-rails"
  spec.metadata["changelog_uri"]   = "https://github.com/ciscolive/zabbix-rails/blob/main/README.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails"
end
