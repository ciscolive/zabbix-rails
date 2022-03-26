# frozen_string_literal: true

require "zabbix/version"
require "zabbix/config"
require "zabbix/connector"
require "zabbix/host_monitor"
require "zabbix/item_trigger"
require "zabbix/dns_monitor"

# 加载外部依赖
require "active_support/concern"
require "zabbix_manager"

module Zabbix
  extend ::ActiveSupport::Concern

  class << self
    attr_accessor :url, :user, :password, :debug

    def configure(&block)
      Config.configure(&block)
    end
  end
end
