FROM ruby:2.7.0-slim-buster

RUN apt-get update && apt-get install -y \
    curl \
    build-essential\
    libpq-dev && \
    curl -sl https://deb.nodesource.com/setup_14.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y nodejs yarn && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

RUN bundle exec rails assets:precompile

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]