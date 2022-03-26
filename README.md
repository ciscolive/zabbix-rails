# Zabbix-Rails
主要实现 zabbix_connector 对象缓存，加速 API 交互效率。 依赖 zabbix_manager 作为后端请求模块

## Usage
```
1、include Zabbix::Connector 到模块或者类对象；
2、调用 zabbix_connector 方法自动实现后端鉴权，当前前提是配置好 'zabbix_rails.rb in config/initializers'
3、调用 Zabbix::HostMonitor 实现自动维护监控对象
4、调用 Zabbix::ItemTrigger 实现自动维护触发器对象
5、调用 Zabbix::Dns 实现自动维护 DNS 监控
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem "zabbix-rails"
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install zabbix-rails
```

add zabbix_rails.rb in config/initializers

```
# Zabbix.configure do |config|
# c.url      = Rails.application.credentials.zabbix.url
# c.user     = Rails.application.credentials.zabbix.username
# c.password = Rails.application.credentials.zabbix.password
# c.debug    = false
# end
```

## Contributing

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
