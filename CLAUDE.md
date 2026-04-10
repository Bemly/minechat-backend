# CLAUDE.md

此文件为 Claude Code (claude.ai/code) 提供项目指引。

## 项目概览

**Minechat** 是一个纯 Ruby 构建的聊天应用，采用 Monorepo 结构，包含三个子项目：

| 项目 | 路径 | 说明 |
|------|------|------|
| 后端 API | `backend/` | Rails 8.1 API-only，提供 RESTful 接口 |
| Web 前端 | `frontend/` | Rails 8.1 全栈应用，消费后端 API |
| GUI 客户端 | `gui/` | Shoes 4 桌面应用，基础框架 |

### 技术栈
- Ruby 3.4.4, Rails 8.1
- PostgreSQL
- jsonapi-serializer (JSON:API 序列化)
- HTTParty (前端调用后端 API)
- Solid Cache / Solid Queue / Solid Cable
- Kamal (部署)

## 常用命令

### 后端 (`backend/`)
```bash
cd backend
bundle install
bin/rails db:create db:migrate    # 创建并迁移数据库
bin/rails s                        # 启动服务器 (默认 3000 端口)
bin/rails test                     # 运行测试
bin/rails test test/controllers/users_controller_test.rb  # 运行单个测试
bin/rubocop                        # 代码风格检查
bin/brakeman                       # 安全扫描
```

### 前端 (`frontend/`)
```bash
cd frontend
bundle install
bin/rails db:create db:migrate     # 创建并迁移数据库
MINECHAT_API_URL=http://localhost:3000 bin/rails s -p 3001  # 启动前端
bin/rails test                     # 运行测试
```

### GUI (`gui/`)
```bash
cd gui
bundle install
MINECHAT_API_URL=http://localhost:3000 bundle exec ruby main.rb
```

## 架构设计

### 后端 API 结构

**模型关系：**
```
User ──< has_many >── SentMessages (Message)
  └──< has_many >── CreatedRooms (Room)
  └──< has_many >── Members ──< through >── Rooms

Room ──< has_many >── Messages
     ──< has_many >── Members
     ──< belongs_to >── Creator (User)
     ──< has_many >── Users (through Members)

Message ──< belongs_to >── Sender (User)
        ──< belongs_to >── Room
        ──< has_many >── MembersWhoLastRead (Member, via unread_id)

Member ──< belongs_to >── Room
       ──< belongs_to >── User
       ──< belongs_to >── UnreadMessage (Message, optional)
```

### RESTful 路由

| 资源 | 路由 | 操作 |
|------|------|------|
| users | GET/POST /users, GET/PATCH/DELETE /users/:id | 完整 CRUD |
| rooms | GET/POST /rooms, GET/PATCH/DELETE /rooms/:id | 完整 CRUD |
| messages (嵌套) | GET/POST /rooms/:room_id/messages | 获取/创建 |
| messages (独立) | GET/PATCH/DELETE /messages/:id | 查看/更新/删除 |
| members (嵌套) | GET/POST/DELETE /rooms/:room_id/members | 列表/添加/移除 |

### 前端架构

- 通过 `ApiClient` 服务类 (`app/services/api_client.rb`) 与后端通信
- 所有业务数据从后端 API 获取，前端无独立数据库逻辑
- 使用 ERB 视图渲染页面
- 环境变量 `MINECHAT_API_URL` 配置后端地址

### GUI 架构

- 基于 Shoes 4，单文件 `main.rb` 入口
- 通过 HTTParty 直接调用后端 API
- 包含登录界面和聊天窗口骨架

## 重要注意事项

1. **无认证系统** — 当前 `sender_id` 和 `creator_id` 直接从客户端参数获取，生产环境需要从认证用户派生
2. **密码明文存储** — `passwd` 字段未加密，无 bcrypt 集成
3. **纯 Ruby 技术栈** — 项目不使用 JavaScript 框架，仅 Ruby
4. **API 响应格式** — 使用 JSON:API 规范 (jsonapi-serializer)

## 文件结构

```
minechat/
├── backend/              # Rails API
│   ├── app/
│   │   ├── controllers/  # users, rooms, messages, members
│   │   ├── models/       # user, room, message, member
│   │   └── serializers/  # jsonapi-serializer
│   ├── config/
│   ├── db/
│   └── test/
├── frontend/             # Rails Web 客户端
│   ├── app/
│   │   ├── controllers/  # home, users, rooms
│   │   ├── services/     # api_client.rb
│   │   └── views/        # ERB 模板
│   ├── config/
│   └── db/
├── gui/                  # Shoes 4 桌面客户端
│   ├── Gemfile
│   └── main.rb
├── CLAUDE.md
├── README.md
└── .gitignore
```
