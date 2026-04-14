FROM docker.1ms.run/library/ruby:3.3.11-slim

WORKDIR /app

# 安装构建依赖（libxml2 给 ibm_db gem 用）
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      curl \
      git \
      libjemalloc2 \
      libstdc++6 \
      libxml2 \
      libyaml-dev \
      pkg-config && \
    rm -rf /var/lib/apt/lists

ENV BUNDLE_PATH="/usr/local/bundle"

# 安装 gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# 复制应用代码
COPY . .
RUN chmod +x bin/* && sed -i "s/\r$//g" bin/*

EXPOSE 3000

CMD ["bin/docker-entrypoint"]
