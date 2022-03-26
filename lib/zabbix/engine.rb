# frozen_string_literal: true

module Zabbix
  class Engine < ::Rails::Engine
    isolate_namespace Zabbix

    initializer("zabbix-rails", after: :load_config_initializers) do |app|
      Rails.application.routes.prepend do
        mount Zabbix::Engine, at: "/zabbix-rails"
      end
    end
  end
end
