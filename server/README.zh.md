# Minechat Server

Rails 7.2.3.1 + Phlex，提供 Web 前端页面和 Marshal API。

[English](README.md)

## 部署方式

### Docker（推荐）

```bash
cd server
docker compose up -d
```

三个容器：Rails 服务器 + Sidekiq、IBM DB2、Redis。

- Web 应用：http://localhost:50001
- DB2：localhost:50000

运行迁移：
```bash
docker compose exec web bin/rails db:migrate
```

### 原生部署

需要本地安装 Ruby 3.3.11、IBM DB2、Redis。

```bash
bundle install
bin/rails db:create db:migrate
bin/rails s
```

另开终端启动 Sidekiq：
```bash
bundle exec sidekiq
```

## 技术栈

- Ruby 3.3.11
- Rails 7.2.3.1
- IBM DB2 (ibm_db >= 5.6.1)
- Redis + Sidekiq
- Phlex (HTML 组件，零 ERB 模板)
- Ruby Marshal (API 序列化)

## 测试

```bash
bin/rails test
bin/rails test test/controllers/users_controller_test.rb
```

## 代码质量

```bash
bin/rubocop
bin/brakeman
```
