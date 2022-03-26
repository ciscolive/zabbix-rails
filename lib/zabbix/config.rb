# frozen_string_literal: true

module Zabbix
  class Config
    class << self
      attr_accessor :url, :user, :password, :debug

      def configure
        yield self
      end
    end
  end
end
