require "active_support/concern"

module Zabbix
  extend ActiveSupport::Concern

  module Chart
    # 请求生成 graph_chart 对象
    def graph_chart(graphid, height = 400, width = 900, start_at = "now-6h", end_at = "now")
      # 构造数据结构
      data = {
        from:    start_at,
        to:      end_at,
        graphid: graphid,
        height:  height,
        width:   width
      }
      # 请求后端返回图片对象
      _item_chart("/chart2.php", data)
    end

    # 请求生成 item_chart 对象
    def item_chart(itemid, height = 400, width = 900, start_at = "now-6h", end_at = "now")
      # 构造数据结构
      data = {
        from:    start_at,
        to:      end_at,
        itemids: [itemid.to_i],
        height:  height,
        width:   width
      }
      # 请求后端返回图片对象
      _item_chart(data)
    end

    # 请求后端返回图形
    def _item_chart(url = "/chart.php", data)
      # 请求接口
      @conn.get "#{url}" do |r|
        r.params.merge!(data)
        r.headers["Host"]   = Config.url.gsub!(%r{http(s)?://}, "")
        r.headers["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9"
        r.headers["Cookie"] = zabbix_token
      end.body
    end

    # 保存图片并返回文件名
    def save_chart_graph(itemid, height = 400, width = 900, start_at = "now-6h", end_at = "now")
      filename = generate_name(itemid)
      save_file(filename, item_chart(itemid, height, width, start_at, end_at))
      "chart/#{File.basename(filename)}"
    end

    # 保存图片
    def save_file(filename, content)
      # 生成绝对路径地址
      filename.prepend("app/assets/images/chart/")

      # 存储数据
      File.open(filename, "wb") do |chart|
        chart.write(content)
      end
    end

    def generate_name(itemid)
      require "uuidtools"
      "#{UUIDTools::UUID.timestamp_create}-#{itemid}.png"
    end
  end
end
