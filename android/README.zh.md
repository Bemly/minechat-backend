# Minechat Android

使用 Ruboto 的 Android 应用。

## 使用

```bash
cd android
bundle install
rake ruboto:setup  # 首次运行，配置 Android SDK
MINECHAT_API_URL=http://10.0.2.2:3000 rake build
rake install       # 安装到模拟器或设备
```

> 注意: Ruboto 仍在开发中，Android 客户端功能可能不稳定。

## 技术栈

- Ruby
- Ruboto
