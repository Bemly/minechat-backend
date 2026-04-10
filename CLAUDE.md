# CLAUDE.md

此文件为 Claude Code (claude.ai/code) 提供项目指引。

## 项目概览

**Minechat** 是一个纯 Ruby 构建的聊天应用，采用 Monorepo 结构，包含五个子项目：

| 项目 | 路径 | 说明 |
|------|------|------|
| 后端 API | `backend/` | Rails 8.1 API-only，提供 RESTful 接口 |
| Web 前端 | `frontend/` | Rails 8.1 全栈应用，消费后端 API |
| TUI 客户端 | `tui/` | 终端界面，使用 cli-ui |
| GUI 客户端 | `gui/` | Shoes 4 桌面应用 |
| Android 客户端 | `android/` | Ruboto Android 应用 |

### 技术栈
- Ruby 3.4.4, Rails 8.1
- IBM DB2 数据库
- Redis (Sidekiq + Action Cable)
- Sidekiq (后台任务处理)
- jsonapi-serializer (JSON:API 序列化)
- HTTParty (HTTP 客户端)
- cli-ui (终端 UI)
- Shoes 4 (桌面 GUI)
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
bin/rails db:create db:migrate
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

### 数据库 (IBM DB2)

- 适配器: `ibm_db` gem
- 默认端口: 50000
- 默认 Schema: `DB2INST1`
- 连接参数通过 `config/database.yml` 或环境变量配置

### 客户端架构

- **前端 (Rails Web)**: 通过 `ApiClient` 服务类调用后端 API
- **TUI (cli-ui)**: 交互式终端界面，使用 `CLI::UI::Frame` 和 `CLI::UI::prompt`
- **GUI (Shoes 4)**: 单文件 `main.rb` 入口，Shoes DSL 构建界面
- **Android (Ruboto)**: Ruby 编写的 Android Activity，使用原生 UI 组件

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
│   │   ├── sidekiq.yml   # Sidekiq 队列配置
│   │   └── ...
│   ├── db/
│   └── test/
├── frontend/             # Rails Web 客户端
│   ├── app/
│   │   ├── controllers/  # home, users, rooms
│   │   ├── services/     # api_client.rb
│   │   └── views/        # ERB 模板
│   ├── config/
│   └── db/
├── tui/                  # cli-ui 终端客户端
│   ├── main.rb           # TUI 应用
│   └── bin/tui           # 入口脚本
├── gui/                  # Shoes 4 桌面客户端
│   ├── Gemfile
│   └── main.rb
├── android/              # Ruboto Android 客户端
│   ├── Rakefile
│   ├── Gemfile
│   └── src/com/minechat/app/
│       └── main_activity.rb  # LoginActivity, MainActivity, ChatActivity
├── CLAUDE.md
├── README.md
└── .gitignore
```
