FROM ruby:3.1.3
RUN apt-get update && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y postgresql-client --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /sample_app
WORKDIR /sample_app
ADD Gemfile /sample_app/Gemfile
ADD Gemfile.lock /sample_app/Gemfile.lock

RUN gem install bundler
RUN bundle install
RUN rails db:reset
RUN rails db:seed
RUN rails db:migrate

ADD . /sample_app