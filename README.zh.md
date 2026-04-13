# Minechat

纯 Ruby 构建的聊天应用，采用 Monorepo 结构，包含五个子项目：

| 项目 | 技术 | 说明 |
|------|------|------|
| [backend/](backend/) | Rails API | RESTful API 服务端，提供用户、房间、消息、成员管理 |
| [frontend/](frontend/) | Rails Web + Phlex | Web 客户端，通过 HTTP 调用 backend API，零 ERB 模板 |
| [tui/](tui/) | cli-ui | 终端界面客户端，交互式聊天 |
| [gui/](gui/) | Gosu | 桌面 2D GUI 客户端，图形界面 |
| [android/](android/) | Ruboto | Android 应用，原生界面 |

[English](README.md)

## 快速开始

### 后端 (Rails API)

```bash
cd backend
bundle install
bin/rails db:create db:migrate db:seed
bin/rails s  # 默认端口 3000
```

启动 Sidekiq 处理后台任务：
```bash
bundle exec sidekiq
```

或使用 `bin/dev` 同时启动服务器和 Sidekiq：
```bash
bin/dev
```

### 前端 (Rails Web)

```bash
cd frontend
bundle install
MINECHAT_API_URL=http://localhost:3000 bin/rails s -p 3001
```

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

## Docker

```bash
cd docker
cp .env.example .env
make up-dev        # 启动开发环境
make migrate       # 数据库迁移
```

包含四个服务：web (端口 3000)、sidekiq、PostgreSQL、Redis。支持 arm64 和 x64 多架构。

## 技术栈

- Ruby 3.4.4
- Rails 8.1
- PostgreSQL 数据库
- Redis (Sidekiq + Action Cable)
- Sidekiq (后台任务)
- jsonapi-serializer (JSON:API 序列化)
- HTTParty (HTTP 客户端)
- Phlex (HTML 组件，零 ERB 模板)
- cli-ui (终端界面)
- Gosu (桌面 2D GUI)
- Ruboto (Android)

## 测试

```bash
# 后端测试
cd backend && bin/rails test

# 前端测试
cd frontend && bin/rails test

# 运行单个测试文件
cd backend && bin/rails test test/controllers/users_controller_test.rb
```

## 代码质量

```bash
cd backend && bin/rubocop   # 代码风格检查
cd backend && bin/brakeman   # 安全扫描
```
