# Minechat

纯 Ruby 构建的聊天应用，采用 Monorepo 结构，包含五个子项目：

| 项目 | 技术 | 说明 |
|------|------|------|
| [backend/](backend/) | Rails API | RESTful API 服务端，提供用户、房间、消息、成员管理 |
| [frontend/](frontend/) | Rails Web | Web 客户端，通过 HTTP 调用 backend API，使用 ERB 视图 |
| [tui/](tui/) | cli-ui | 终端界面客户端，交互式聊天 |
| [gui/](gui/) | Shoes 4 | 桌面 GUI 客户端，基础框架 |
| [android/](android/) | Ruboto | Android 应用，原生界面 |

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
bin/rails db:create db:migrate
MINECHAT_API_URL=http://localhost:3000 bin/rails s -p 3001
```

### TUI 客户端

```bash
cd tui
bundle install
MINECHAT_API_URL=http://localhost:3000 bundle exec ruby main.rb
```

### GUI 客户端 (Shoes 4)

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

> 注意: Shoes 4 和 Ruboto 仍在开发中，客户端功能可能不稳定。

## 技术栈

- Ruby 3.4.4
- Rails 8.1
- IBM DB2 数据库
- Redis (Sidekiq + Action Cable)
- Sidekiq (后台任务)
- jsonapi-serializer (JSON:API 序列化)
- HTTParty (HTTP 客户端)
- cli-ui (终端界面)
- Shoes 4 (桌面 GUI)
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
