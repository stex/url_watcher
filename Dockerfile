FROM ruby:3-alpine

COPY ./watcher.rb ./watcher.rb
CMD ["ruby", "watcher.rb"]
