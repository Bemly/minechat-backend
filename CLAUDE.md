# CLAUDE.md

此文件为 Claude Code (claude.ai/code) 提供项目指引。

## 项目概览

**Minechat** 是一个纯 Ruby 构建的聊天应用，采用 Monorepo 结构，包含五个子项目：

| 项目 | 路径 | 说明 |
|------|------|------|
| 后端 API | `backend/` | Rails 8.1 API-only，提供 RESTful 接口 |
| Web 前端 | `frontend/` | Rails 8.1 + Phlex，纯 Ruby HTML 组件（零 .erb 模板） |
| TUI 客户端 | `tui/` | 终端界面，使用 cli-ui |
| GUI 客户端 | `gui/` | Gosu 2D 图形桌面应用 |
| Android 客户端 | `android/` | Ruboto Android 应用 |

### 技术栈
- Ruby 3.4.4, Rails 8.1
- PostgreSQL 数据库
- Redis (Sidekiq + Action Cable)
- Sidekiq (后台任务处理)
- jsonapi-serializer (JSON:API 序列化)
- HTTParty (HTTP 客户端)
- Phlex (前端 HTML 组件，替代 ERB 模板)
- cli-ui (终端 UI)
- Gosu (桌面 2D GUI)
- Ruboto (Android)

## 常用命令

### 后端 (`backend/`)
```bash
cd backend
bundle install
bin/rails db:create db:migrate    # 创建并迁移数据库
bin/rails s                        # 启动 API 服务器 (默认 3000 端口)
bundle exec sidekiq                # 启动 Sidekiq
bin/dev                            # 同时启动服务器和 Sidekiq
bin/rails test                     # 运行测试
bin/rails test test/controllers/users_controller_test.rb  # 单个测试
bin/rubocop                        # 代码风格检查
bin/brakeman                       # 安全扫描
```

### 前端 (`frontend/`)
```bash
cd frontend
bundle install
MINECHAT_API_URL=http://localhost:3000 bin/rails s -p 3001
```

### TUI 客户端 (`tui/`)
```bash
cd tui
bundle install
MINECHAT_API_URL=http://localhost:3000 bundle exec ruby main.rb
```

### GUI 客户端 (`gui/`)
```bash
cd gui
bundle install
MINECHAT_API_URL=http://localhost:3000 bundle exec ruby main.rb
```

### Android 客户端 (`android/`)
```bash
cd android
bundle install
rake ruboto:setup                  # 配置 Android SDK
MINECHAT_API_URL=http://10.0.2.2:3000 rake build
rake install                       # 安装到设备
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

### 后台任务 (Sidekiq)

- 使用 Redis 作为消息代理
- 配置文件: `backend/config/sidekiq.yml`
- 开发模式: `bin/dev` 同时启动 Rails + Sidekiq

### 数据库 (PostgreSQL)

- 适配器: `pg` gem
- 开发数据库: `minechat_development` / `minechat_test`
- 前端数据库: `minechat_frontend_development` / `minechat_frontend_test`
- 生产环境通过 `DATABASE_URL` 环境变量配置

### Docker 部署

- `backend/Dockerfile` — 生产用多阶段构建 (ruby:3.4.4-slim)
- `backend/Dockerfile.dev` — 开发用，支持 volume mount 热重载
- `docker/docker-compose.yml` — 生产环境编排 (web + sidekiq + postgres + redis)
- `docker/docker-compose.dev.yml` — 开发环境编排 (代码实时同步)
- `docker/Makefile` — 便捷命令: `make up-dev`, `make migrate`, `make build-multi` 等
- 支持 arm64 和 x64 多架构构建 (docker buildx)

### 前端 (Phlex)

- 零 ERB 模板，全部 Ruby 类 (`app/views/*.rb`)
- `ApplicationView` 基类包含导航栏、flash 消息、CSS 样式
- 每个视图是一个 Phlex 组件类，通过 `render` 调用

### 客户端架构

- **前端 (Phlex)**: 通过 `ApiClient` 服务类调用后端 API
- **TUI (cli-ui)**: 交互式终端界面，使用 `CLI::UI::Frame` 和 `CLI::UI::prompt`
- **GUI (Gosu)**: 2D 图形窗口，包含登录、房间列表、聊天三个界面
  - 注意: Gosu 1.4.6 的 draw_rect/draw_text 是 C++ SWIG 绑定，**不支持关键字参数**，全部使用位置参数
- **Android (Ruboto)**: Ruby 编写的 Android Activity，使用原生 UI 组件

## 重要注意事项

1. **纯 Ruby 技术栈** — 项目不使用 JavaScript 框架或 HTML 模板，仅 Ruby
2. **前端零 HTML** — 所有 HTML 通过 Phlex Ruby 组件生成
3. **无认证系统** — 当前 `sender_id` 和 `creator_id` 直接从客户端参数获取，生产环境需要从认证用户派生
4. **密码明文存储** — `passwd` 字段未加密，无 bcrypt 集成
5. **API 响应格式** — 使用 JSON:API 规范 (jsonapi-serializer)

## 文件结构

```
minechat/
├── backend/              # Rails API
│   ├── Dockerfile        # 生产用多阶段构建
│   ├── Dockerfile.dev    # 开发用 (volume mount)
│   ├── app/
│   │   ├── controllers/  # users, rooms, messages, members
│   │   ├── models/       # user, room, message, member
│   │   └── serializers/  # jsonapi-serializer
│   ├── config/
│   │   ├── sidekiq.yml   # Sidekiq 队列配置
│   │   └── ...
│   ├── db/
│   └── test/
├── docker/               # Docker 编排
│   ├── Docker Compose    # 生产/开发环境编排
│   ├── .env.example      # 环境变量模板
│   └── Makefile          # 便捷命令
├── frontend/             # Rails Web 客户端 (Phlex)
│   ├── app/
│   │   ├── controllers/  # home, users, rooms
│   │   ├── services/     # api_client.rb
│   │   └── views/        # Phlex Ruby 组件 (无 .erb)
│   ├── config/
│   └── db/
├── tui/                  # cli-ui 终端客户端
│   ├── main.rb           # TUI 应用
│   └── bin/tui           # 入口脚本
├── gui/                  # Gosu 桌面客户端
│   ├── Gemfile
│   └── main.rb           # MinechatWindow 类
├── android/              # Ruboto Android 客户端
│   ├── Rakefile
│   ├── Gemfile
│   └── src/com/minechat/app/
│       └── main_activity.rb  # LoginActivity, MainActivity, ChatActivity
├── CLAUDE.md
├── README.md
└── .gitignore
```
