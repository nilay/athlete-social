default: setup start
setup: install env db

install:
	@bundle install

clean:
	@echo 'clean task not implemented'

build:
	@echo 'build task not implemented'

start:
	@bundle exec rails s -b 0.0.0.0

console:
	@bundle exec rails c

test:
	@bundle exec rspec

# internal-only
env:
	@cp sample.env .env

db:
	@rake db:create db:migrate db:seed

.PHONY: install clean build start test console
