# CLAUDE.md

此文件为 Claude Code (claude.ai/code) 提供项目指引。

## 项目概览

**Minechat** 是一个纯 Ruby 构建的聊天应用，采用 Monorepo 结构，包含一个 Rails 应用和三个客户端：

| 项目 | 路径 | 说明 |
|------|------|------|
| Web 应用 | `server/` | Rails 7.2.3.1 + Phlex，前端页面 + Marshal API |
| TUI 客户端 | `tui/` | 终端界面，使用 cli-ui |
| GUI 客户端 | `gui/` | Gosu 2D 图形桌面应用 |
| Android 客户端 | `android/` | Ruboto Android 应用 |

### 技术栈
- Ruby 3.3.11, Rails 7.2.3.1
- IBM DB2 数据库（ibm_db gem >= 5.6.1，最高版本 5.6.1，**不存在 6.0**）
- Redis (Sidekiq + Action Cable)
- Sidekiq (后台任务处理)
- Phlex (前端 HTML 组件，替代 ERB 模板)
- cli-ui (终端 UI)
- Gosu (桌面 2D GUI)
- Ruboto (Android)

## 常用命令

### Web 应用 (`server/`)

**Docker 部署（推荐）：**
```bash
cd server
docker compose up -d              # 启动三个容器：web、db2、redis
docker compose exec web bin/rails db:migrate  # 数据库迁移
```

**原生部署：**
```bash
cd server
bundle install
bin/rails db:create db:migrate    # 创建并迁移数据库
bin/rails s                        # 启动服务器 (默认 3000 端口)
bundle exec sidekiq                # 另开终端启动 Sidekiq
bin/rails test                     # 运行测试
bin/rails test test/controllers/users_controller_test.rb  # 单个测试
bin/rubocop                        # 代码风格检查
bin/brakeman                       # 安全扫描
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

### 整体架构

```
Web 前端 ──ActiveRecord──→ IBM DB2
API (`/api/`) ──Marshal──→ TUI / GUI / Android
```

- **前端页面** 直接用 ActiveRecord 连接 DB2，传统 Rails 服务端渲染（Phlex 组件）
- **API 接口** 在 `/api/` 命名空间下，通过 Marshal 序列化，供 TUI/GUI/Android 客户端使用

### 模型关系

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

**前端页面（无前缀）：**

| 资源 | 路由 | 操作 |
|------|------|------|
| users | GET/POST /users, GET/PATCH/DELETE /users/:id | 完整 CRUD |
| rooms | GET/POST /rooms, GET/PATCH/DELETE /rooms/:id | 完整 CRUD |
| messages (嵌套) | GET/POST /rooms/:room_id/messages | 获取/创建 |
| members (嵌套) | GET/POST/DELETE /rooms/:room_id/members | 列表/添加/移除 |

**API 接口（`/api/` 前缀）：**

| 资源 | 路由 |
|------|------|
| /api/users | 完整 CRUD |
| /api/rooms | 完整 CRUD |
| /api/rooms/:room_id/messages | 嵌套 |
| /api/rooms/:room_id/members | 嵌套 |
| /api/messages/:id | 独立操作 |

### API 序列化

- 使用 Ruby Marshal 序列化，Content-Type: `application/octet-stream`
- `ApplicationController` 提供 `marshal_render(data, status:)` 方法
- 客户端用 `Marshal.load(response.body)` 反序列化

### 后台任务 (Sidekiq)

- 使用 Redis 作为消息代理
- 配置文件: `config/sidekiq.yml`
- Docker 模式: Sidekiq 和 Rails 在同一容器内启动（`bin/docker-entrypoint`）
- 原生模式: `bundle exec sidekiq` 单独启动

### 数据库 (IBM DB2)

- 适配器: `ibm_db` gem（版本 >= 5.6.1，不存在 6.0）
- 默认端口: 50000
- 默认 Schema: `DB2INST1`
- 连接参数通过 `config/database.yml` 或环境变量配置
- **重要**: ibm_db 连接后必须开启自动提交，否则 DML（INSERT/UPDATE/DELETE）不会自动提交，后续查询会返回 false
  ```ruby
  IBM_DB.autocommit(conn, IBM_DB::SQL_AUTOCOMMIT_ON)
  ```
- **DB2 DDL 注意**: PRIMARY KEY 列必须显式声明 `NOT NULL`（不同于其他数据库）

### 前端 (Phlex)

- 零 ERB 模板，全部 Ruby 类 (`app/views/*.rb`)
- `ApplicationView` 基类包含导航栏、flash 消息、CSS 样式
- 每个视图是一个 Phlex 组件类，通过 `render` 调用

### 客户端架构

- **TUI (cli-ui)**: 交互式终端界面，通过 HTTP 调 `/api/` Marshal API
- **GUI (Gosu)**: 2D 图形窗口，通过 HTTP 调 `/api/` Marshal API
  - 注意: Gosu 1.4.6 的 draw_rect/draw_text 是 C++ SWIG 绑定，**不支持关键字参数**，全部使用位置参数
- **Android (Ruboto)**: Ruby 编写的 Android Activity，通过 HTTP 调 `/api/` Marshal API

## 重要注意事项

1. **纯 Ruby 技术栈** — 项目不使用 JavaScript 框架或 HTML 模板，仅 Ruby
2. **前端零 HTML** — 所有 HTML 通过 Phlex Ruby 组件生成
3. **无认证系统** — 当前 `sender_id` 和 `creator_id` 直接从客户端参数获取，生产环境需要从认证用户派生
4. **密码明文存储** — `passwd` 字段未加密，无 bcrypt 集成
5. **API 序列化** — 使用 Ruby Marshal（非 JSON），客户端需 `Marshal.load` 反序列化
6. **每次更改后提交** — 完成任何代码修改后，必须 git commit 并推送到 GitHub

## 文件结构

```
minechat/
├── server/                            # Rails Web 应用
│   ├── app/
│   │   ├── controllers/
│   │   │   ├── application_controller.rb
│   │   │   ├── home_controller.rb         # 首页
│   │   │   ├── users_controller.rb        # 前端用户页面
│   │   │   ├── rooms_controller.rb        # 前端房间页面
│   │   │   ├── errors_controller.rb       # 错误页
│   │   │   └── api/                       # Marshal API
│   │   │       ├── users_controller.rb
│   │   │       ├── rooms_controller.rb
│   │   │       ├── messages_controller.rb
│   │   │       └── members_controller.rb
│   │   ├── models/                        # User, Room, Message, Member
│   │   └── views/                         # Phlex 组件 (无 .erb)
│   ├── bin/
│   ├── config/
│   │   ├── database.yml                   # IBM DB2 连接
│   │   ├── sidekiq.yml                    # Sidekiq 队列配置
│   │   └── ...
│   ├── db/migrate/                        # 数据库迁移
│   ├── test/
│   ├── Dockerfile
│   ├── docker-compose.yml             # web + db2 + redis
│   └── Gemfile
├── tui/                               # cli-ui 终端客户端
├── gui/                               # Gosu 桌面客户端
├── android/                           # Ruboto Android 客户端
├── CLAUDE.md
├── README.md
└── README.zh.md
```
