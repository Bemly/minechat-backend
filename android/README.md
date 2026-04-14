# Minechat Android

Android app using Ruboto.

## Usage

```bash
cd android
bundle install
rake ruboto:setup  # first time only, configure Android SDK
MINECHAT_API_URL=http://10.0.2.2:3000 rake build
rake install       # install to emulator or device
```

> Note: Ruboto is still under development. The Android client may be unstable.

## Tech Stack

- Ruby
- Ruboto
