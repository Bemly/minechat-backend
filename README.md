# Minechat

A chat application built entirely in Ruby, using a Monorepo structure with one Rails app and three clients:

| Project | Tech | Description |
|---------|------|-------------|
| [server/](server/) | Rails + Phlex | Web frontend with server-side rendering + Marshal API at `/api/` |
| [tui/](tui/) | cli-ui | Terminal UI client, interactive chat |
| [gui/](gui/) | Gosu | Desktop 2D GUI client, graphical interface |
| [android/](android/) | Ruboto | Android app, native UI |

[中文文档](README.zh.md)

## Deployment

### Option 1: Docker (recommended)

```bash
cd server
docker compose up -d
```

This starts three containers: Rails server + Sidekiq, IBM DB2, Redis.

- Web app: http://localhost:3000
- DB2: localhost:50000

Run database migrations:
```bash
cd server
docker compose exec web bin/rails db:migrate
```

### Option 2: Native

Requirements: Ruby 3.3.11, IBM DB2, Redis installed locally.

```bash
cd server
bundle install
bin/rails db:create db:migrate
bin/rails s  # default port 3000
```

Start Sidekiq in another terminal:
```bash
cd server
bundle exec sidekiq
```

## Clients

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

## Tech Stack

- Ruby 3.3.11
- Rails 7.2.3.1
- IBM DB2 (ibm_db >= 5.6.1)
- Redis (Sidekiq)
- Sidekiq (background jobs)
- Phlex (HTML components, zero ERB templates)
- Ruby Marshal (API serialization)
- cli-ui (terminal UI)
- Gosu (desktop 2D GUI)
- Ruboto (Android)

## Testing

```bash
cd server && bin/rails test

# Run a single test file
cd server && bin/rails test test/controllers/users_controller_test.rb
```

## Code Quality

```bash
cd server && bin/rubocop   # style check
cd server && bin/brakeman   # security scan
```
