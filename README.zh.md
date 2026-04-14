# Minechat

纯 Ruby 构建的聊天应用，采用 Monorepo 结构，包含一个 Rails 应用和三个客户端：

| 项目 | 技术 | 说明 |
|------|------|------|
| [server/](server/) | Rails + Phlex | 前端页面服务端渲染 + `/api/` Marshal API |
| [tui/](tui/) | cli-ui | 终端界面客户端，交互式聊天 |
| [gui/](gui/) | Gosu | 桌面 2D GUI 客户端，图形界面 |
| [android/](android/) | Ruboto | Android 应用，原生界面 |

[English](README.md)

## 部署方式

### 方式一：Docker（推荐）

```bash
cd docker
docker compose up -d
```

启动三个容器：Rails 服务器 + Sidekiq、IBM DB2、Redis。

- Web 应用：http://localhost:3000
- DB2：localhost:50000

运行数据库迁移：
```bash
cd docker
docker compose exec web bin/rails db:migrate
```

### 方式二：原生部署

需要本地安装 Ruby 3.3.11、IBM DB2、Redis。

```bash
cd server
bundle install
bin/rails db:create db:migrate
bin/rails s  # 默认端口 3000
```

另开一个终端启动 Sidekiq：
```bash
cd server
bundle exec sidekiq
```

## 客户端

### TUI 客户端

```bash
cd tui
bundle install
MINECHAT_API_URL=http://localhost:3000 bundle exec ruby main.rb
```

### GUI 客户端 (Gosu)

```bash
cd gui
bundle install
MINECHAT_API_URL=http://localhost:3000 bundle exec ruby main.rb
```

### Android 客户端 (Ruboto)

```bash
cd android
bundle install
rake ruboto:setup  # 首次运行，配置 Android SDK
MINECHAT_API_URL=http://10.0.2.2:3000 rake build
rake install       # 安装到模拟器或设备
```

> 注意: Ruboto 仍在开发中，Android 客户端功能可能不稳定。

## 技术栈

- Ruby 3.3.11
- Rails 7.2.3.1
- IBM DB2 (ibm_db >= 5.6.1)
- Redis (Sidekiq)
- Sidekiq (后台任务)
- Phlex (HTML 组件，零 ERB 模板)
- Ruby Marshal (API 序列化)
- cli-ui (终端界面)
- Gosu (桌面 2D GUI)
- Ruboto (Android)

## 测试

```bash
cd server && bin/rails test

# 运行单个测试文件
cd server && bin/rails test test/controllers/users_controller_test.rb
```

## 代码质量

```bash
cd server && bin/rubocop   # 代码风格检查
cd server && bin/brakeman   # 安全扫描
```
