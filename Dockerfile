FROM ruby:3.2.2

WORKDIR /usr/src/app

COPY lib/ ./lib
COPY Gemfile ./

RUN bundle install

CMD ["ruby", "./lib/backup.rb"]
