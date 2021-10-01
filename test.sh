pg_ctl -D /usr/local/var/postgres start
bundle exec rake ts:rebuild RAILS_ENV='test'
bundle exec sidekiq --environment test -C config/sidekiq.yml

