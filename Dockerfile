FROM ruby:3.1.3
RUN apt-get update -qq && apt-get install -y nodejs yarnpkg
RUN ln -s /usr/bin/yarnpkg /usr/bin/yarn
RUN mkdir /app
WORKDIR /sample_app
COPY Gemfile /sample_app/Gemfile
COPY Gemfile.lock /sample_app/Gemfile.lock

RUN gem install bundler
RUN bundle install
COPY . /app

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000