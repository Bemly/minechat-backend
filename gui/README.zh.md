# Minechat GUI

使用 Gosu 的桌面 2D GUI 客户端。

## 使用

```bash
cd gui
bundle install
MINECHAT_API_URL=http://localhost:3000 bundle exec ruby main.rb
```

## 技术栈

- Ruby
- Gosu

> Gosu 1.4.6 的 draw_rect/draw_text 是 C++ SWIG 绑定，**不支持关键字参数**，全部使用位置参数。
