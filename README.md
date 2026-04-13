# Minechat

A chat application built entirely in Ruby, using a Monorepo structure with five sub-projects:

| Project | Tech | Description |
|---------|------|-------------|
| [backend/](backend/) | Rails API | RESTful API server for users, rooms, messages, and members |
| [frontend/](frontend/) | Rails Web + Phlex | Web client, calls backend API via HTTP, zero ERB templates |
| [tui/](tui/) | cli-ui | Terminal UI client, interactive chat |
| [gui/](gui/) | Gosu | Desktop 2D GUI client, graphical interface |
| [android/](android/) | Ruboto | Android app, native UI |

[中文文档](README.zh.md)

## Quick Start

### Backend (Rails API)

```bash
cd backend
bundle install
bin/rails db:create db:migrate db:seed
bin/rails s  # default port 3000
```

Start Sidekiq for background jobs:
```bash
bundle exec sidekiq
```

Or use `bin/dev` to start both server and Sidekiq:
```bash
bin/dev
```

### Frontend (Rails Web)

```bash
cd frontend
bundle install
MINECHAT_API_URL=http://localhost:3000 bin/rails s -p 3001
```

### TUI Client

```bash
cd tui
bundle install
MINECHAT_API_URL=http://localhost:3000 bundle exec ruby main.rb
```

### GUI Client (Gosu)

```bash
cd gui
bundle install
MINECHAT_API_URL=http://localhost:3000 bundle exec ruby main.rb
```

### Android Client (Ruboto)

```bash
cd android
bundle install
rake ruboto:setup  # first time only, configure Android SDK
MINECHAT_API_URL=http://10.0.2.2:3000 rake build
rake install       # install to emulator or device
```

> Note: Ruboto is still under development. The Android client may be unstable.

## Docker

```bash
cd docker
cp .env.example .env
make up-dev        # start development environment
make migrate       # run database migrations
```

Services: web (port 3000), sidekiq, PostgreSQL, Redis. Supports both arm64 and x64 architectures.

## Tech Stack

- Ruby 3.4.4
- Rails 8.1
- PostgreSQL
- Redis (Sidekiq + Action Cable)
- Sidekiq (background jobs)
- jsonapi-serializer (JSON:API serialization)
- HTTParty (HTTP client)
- Phlex (HTML components, zero ERB templates)
- cli-ui (terminal UI)
- Gosu (desktop 2D GUI)
- Ruboto (Android)

## Testing

```bash
# Backend tests
cd backend && bin/rails test

# Frontend tests
cd frontend && bin/rails test

# Run a single test file
cd backend && bin/rails test test/controllers/users_controller_test.rb
```

## Code Quality

```bash
cd backend && bin/rubocop   # style check
cd backend && bin/brakeman   # security scan
```
