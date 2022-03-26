# frozen_string_literal: true

require "active_support/concern"

module Zabbix
  module HostMonitor
    extend ::ActiveSupport::Concern

    include Zabbix::Connector

    # 创建或更新 HostMonitor主机监控对象
    def refresh_zabbix_host(item)
      if zabbix_connector.present? && (zabbix_connector.is_a? ZabbixManager)
        # 查询已关联的 hostid
        hostid = item[:hostid]

        # 封装数据之前确保设备属组已经存在
        search_id = zabbix_connector.hosts.get_id(host: item.sn)
        # 构建 zabbix-rails 监控对象数据结构，创建或者更新数据
        if hostid.present?
          if search_id.blank?
            Rails.logger.warn("监控主机信息发生变化，正在创建监控对象: #{item}.inspect")
            Zabbix::DeleteMonitor.perform_now(item.sn)
            zabbix_connector.hosts.create_or_update(item.host_params)
          elsif hostid != search_id
            Rails.logger.warn("ZABBIX已有监控项，正在刷新数据 #{hostid} - #{search_id}")
            search_id
          else
            Rails.logger.warn("正在更新监控对象: #{item.sn} - #{item.name}")
            zabbix_connector.hosts.create_or_update(item.host_params)
          end
        else
          Rails.logger.warn("正在新增监控对象: #{item.sn} - #{item.name}")
          zabbix_connector.hosts.create_or_update(item.host_params)
        end

        # 返回监控对象的 host_id
        Rails.logger.warn("成功执行创建或更新监控主机: #{item.name} #{item.sn}")
        zabbix_connector.hosts.get_id(host: item.sn).presence || nil
      else
        Rails.logger.warn("未获取 ZABBIX_MGMT 对象，无法执行创建或更新监控主机: #{item.name} #{item.sn}")
        nil
      end
    rescue => e
      Rails.logger.warn("无法执行创建或更新监控主机: #{item.name} #{item.sn} #{e}")
    end
  end
end
