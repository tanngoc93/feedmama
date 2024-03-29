#!/bin/bash
set -e

#
bundle check || bundle install

# Export ERD file (Optional)
# bundle exec erd

#
if [ ! -d $APP_DIR/tmp/pids ]; then
  mkdir -p $APP_DIR/tmp/pids
fi

# Remove a potentially pre-existing server.pid for Rails.
if [ -f $APP_DIR/tmp/pids/server.pid ]; then
  rm -f $APP_DIR/tmp/pids/server.pid
fi

bundle exec rails db:create db:migrate seed:migrate && bundle exec puma -C config/puma.rb

exec "$@"