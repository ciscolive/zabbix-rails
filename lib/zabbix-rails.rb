# frozen_string_literal: true

# 注意加载顺序
require "zabbix/version"
require "zabbix/connector"
require "zabbix/host_monitor"
require "zabbix/item_trigger"
require "zabbix/dns_monitor"
require "zabbix/chart"

# 加载外部依赖
require "active_support/concern"
require "zabbix_manager"

module Zabbix
  extend ::ActiveSupport::Concern

  class << self
    attr_accessor :url, :user, :password, :debug

    def config
      yield self
    end
  end
end
