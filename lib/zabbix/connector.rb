# frozen_string_literal: true

require "active_support/concern"
require "faraday"

module Zabbix
  module Connector
    extend ::ActiveSupport::Concern

    # 开发测试环境需要单独开启缓存功能：bin/rails dev:cache
    # 将鉴权后的 zabbix-rails 对象缓存到 Rails，减少不必要的认证动作加速执行
    # https://guides.rubyonrails.org/caching_with_rails.html
    def zabbix_connector
      Rails.cache.fetch("zabbix_connector", expires_in: 30.minutes) do
        Rails.logger.warn("Zabbix 正在请求 API 鉴权")
        ZabbixManager.connect(url: Zabbix.url, user: Zabbix.user, password: Zabbix.password, debug: Zabbix.debug)
      rescue => e
        Rails.logger.warn("登录 ZABBIX 异常，请检查网络或登录凭证。原始报错信息: #{e}")
      end
    end

    # 获取 zabbix 登录凭证缓存
    def zabbix_token
      Rails.cache.fetch("zabbix_token", expires_in: 30.minutes) do
        Rails.logger.warn("正在请求 zabbix/index.php 登录认证")
        authenticate_with_cookie
      end
    end

    # 删除主机监控
    def delete_host_monitor(name)
      id = zabbix_connector.hosts.get_host_id(name)
      if id.present?
        zabbix_connector.hosts.delete(id)
        Rails.logger.warn("执行 delete_host_monitor 接口成功：#{name} - #{id}")
      else
        Rails.logger.warn("调用 delete_host_monitor 接口异常：#{name} - #{id}")
      end
    rescue => e
      Rails.logger.warn("调用 delete_host_monitor 接口异常，原始报错信息: #{e}")
    end

    # 删除监控触发器
    def delete_trigger_monitor(id)
      if id.present?
        zabbix_connector.triggers.delete(id)
        Rails.logger.warn("执行 delete_trigger_monitor 接口成功：#{id}")
      else
        Rails.logger.warn("调用 delete_trigger_monitor 接口异常：#{id}")
      end
    rescue => e
      Rails.logger.warn("调用 delete_trigger_monitor 接口异常，原始报错信息: #{e}")
    end

    # 请求 zabbix 后端认证，返回 Cookie
    def authenticate_with_cookie
      # 初始化会话
      base_url = Zabbix.url
      host     = URI(base_url).host
      conn     = Faraday::Connection.new(base_url)

      # 登录权限凭证
      data = {
        name:      Zabbix.user,
        password:  Zabbix.password,
        autologin: 1,
        enter:     "Sign in",
      }

      # 请求认证
      ret = conn.post("/index.php") do |r|
        r.headers["Host"] = host
        r.body            = data
      end

      # 此处需要特殊处理，否则 V5 版本无法正常加载缓存
      ret.headers["set-cookie"]&.gsub(/ HttpOnly,?/, "").presence || nil
    end
  end
end
