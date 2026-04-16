# Minechat Server

Rails 7.2.3.1 + Phlex，提供 Web 前端页面和 Marshal API。

[中文](README.zh.md)

## Deployment

### Docker (recommended)

```bash
cd server
docker compose up -d
```

Three containers: Rails server + Sidekiq, IBM DB2, Redis.

- Web app: http://localhost:50001
- DB2: localhost:50000

Run migrations:
```bash
docker compose exec web bin/rails db:migrate
```

### Native

Requirements: Ruby 3.3.11, IBM DB2, Redis.

```bash
bundle install
bin/rails db:create db:migrate
bin/rails s
```

Start Sidekiq in another terminal:
```bash
bundle exec sidekiq
```

## Tech Stack

- Ruby 3.3.11
- Rails 7.2.3.1
- IBM DB2 (ibm_db >= 5.6.1)
- Redis + Sidekiq
- Phlex (HTML components, zero ERB templates)
- Ruby Marshal (API serialization)

## Testing

```bash
bin/rails test
bin/rails test test/controllers/users_controller_test.rb
```

## Code Quality

```bash
bin/rubocop
bin/brakeman
```
