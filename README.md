# Minechat

A chat application built entirely in Ruby, using a Monorepo structure with one Rails app and three clients:

| Project | Tech | Description |
|---------|------|-------------|
| Web App (root) | Rails + Phlex | Web frontend with server-side rendering + Marshal API at `/api/` |
| [tui/](tui/) | cli-ui | Terminal UI client, interactive chat |
| [gui/](gui/) | Gosu | Desktop 2D GUI client, graphical interface |
| [android/](android/) | Ruboto | Android app, native UI |

[中文文档](README.zh.md)

## Quick Start

### Web App

```bash
bundle install
bin/rails db:create db:migrate
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
bin/rails test

# Run a single test file
bin/rails test test/controllers/users_controller_test.rb
```

## Code Quality

```bash
bin/rubocop   # style check
bin/brakeman   # security scan
```
