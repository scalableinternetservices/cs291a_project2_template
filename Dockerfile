FROM ruby:3

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN gem install bundler && \
    bundle config --global frozen 1 && \
    bundle install

COPY app.rb config.ru puma.rb ./
CMD exec bundle exec puma -C puma.rb
