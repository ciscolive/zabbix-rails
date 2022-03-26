# frozen_string_literal: true

require "active_support/concern"

module Zabbix
  module ItemTrigger
    extend ::ActiveSupport::Concern

    include Zabbix::Connector

    # 创建或新增触发器，返回触发器ID | 触发器的 DATA_STRUCTURE
    def refresh_trigger(data)
      # Rails.logger.debug("打印入参: #{data}")
      unless data.present?
        Rails.logger.warn("创建或新增监控触发器异常: 请确保 #{data} 数据完整性")
        return
      end

      # 比对记录的数据和数据库查询到的数据是否一致
      triggerid = data["triggerid"]
      if triggerid.present?
        # 比对记录的数据和API查询的数据
        search_id = zabbix_connector.triggers.get_id(triggerids: triggerid, description: data["description"]).to_i

        if search_id == 0
          Rails.logger.warn("触发器信息发生变化，正在创建触发器: #{data["description"]}")
          Zabbix::DeleteTrigger.perform_now(triggerid)
          zabbix_connector.triggers.create_trigger(data)[0]
        elsif triggerid != search_id
          Rails.logger.warn("ZABBIX已有监控项，正在刷新触发器: #{triggerid} - #{data["description"]}")
          Zabbix::DeleteTrigger.perform_now(triggerid)
          search_id
        else
          Rails.logger.warn("正在刷新触发器: #{triggerid} - #{data["description"]}")
          zabbix_connector.triggers.update_trigger(triggerid, data)[0]
        end
      else
        Rails.logger.warn("正在创建触发器: #{data["description"]}")
        zabbix_connector.triggers.create_trigger(data)[0]
      end

    rescue => e
      Rails.logger.warn("更新或创建异常: #{e}")
    end

    # 添加触发器依赖
    def add_trigger_dependency(triggerid, depend_on_trigger_id)
      logger.warn("准备添加触发器依赖：#{triggerid} - #{depend_on_trigger_id}")
      zabbix_connector.triggers.add_trigger_dependency(triggerid, depend_on_trigger_id)
    rescue => e
      logger.warn("创建触发器依赖对象期间捕捉异常：#{e}")
    end
  end
end
