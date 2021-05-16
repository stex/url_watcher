FROM ruby:3-alpine

WORKDIR /app

COPY ./watcher.rb ./watcher.rb
CMD ["ruby", "watcher.rb"]
