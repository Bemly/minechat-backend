# Minechat GUI

Desktop 2D GUI client using Gosu.

## Usage

```bash
cd gui
bundle install
MINECHAT_API_URL=http://localhost:3000 bundle exec ruby main.rb
```

## Tech Stack

- Ruby
- Gosu

> Gosu 1.4.6's draw_rect/draw_text are C++ SWIG bindings and do **not** support keyword arguments. Use positional arguments only.
