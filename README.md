# Minechat

一个用纯 Ruby 构建的聊天应用，包含三个子项目：

| 项目 | 技术 | 说明 |
|------|------|------|
| [backend/](backend/) | Rails API | RESTful API 服务端，提供用户、房间、消息、成员管理 |
| [frontend/](frontend/) | Rails Web | Web 客户端，通过 HTTP 调用 backend API，使用 ERB 视图 |
| [gui/](gui/) | Shoes 4 | 桌面 GUI 客户端，基础框架 |

## 快速开始

### 后端 (Rails API)

```bash
cd backend
bundle install
bin/rails db:create db:migrate db:seed
bin/rails s  # 默认端口 3000
```

### 前端 (Rails Web)

```bash
cd frontend
bundle install
bin/rails db:create db:migrate
MINECHAT_API_URL=http://localhost:3000 bin/rails s -p 3001
```

### GUI 客户端 (Shoes 4)

```bash
cd gui
bundle install
MINECHAT_API_URL=http://localhost:3000 bundle exec ruby main.rb
```

> 注意: Shoes 4 仍在开发中，GUI 功能可能不稳定。

## 技术栈

- Ruby 3.4.4
- Rails 8.1
- PostgreSQL
- Puma
- jsonapi-serializer
- Solid Cache / Solid Queue / Solid Cable
- HTTParty (用于前后端通信)
- Shoes 4 (GUI)

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
