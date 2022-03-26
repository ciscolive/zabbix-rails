# frozen_string_literal: true

require "active_support/concern"

module Zabbix
  extend ::ActiveSupport::Concern

  module DnsMonitor
    include Zabbix::Connector

    # 生成 DNS 触发器表达式
    def dns_trigger_expression(name)
      # 定义告警规则
      expression = "{dns_query_with_localdns:net.dns.record[,#{name},A,2,2].diff()}=1 or {dns_query_with_localdns:net.dns.record[,#{name},A,2,2].nodata(5m)}=1"

      # 定义告警恢复规则
      recovery_expression = "{dns_query_with_localdns:net.dns.record[,#{name},A,2,2].diff()}=0 and {dns_query_with_localdns:net.dns.record[,#{name},A,2,2].nodata(5m)}= 0"
      # 返回计算结果
      [expression, recovery_expression]
    end
  end
end
