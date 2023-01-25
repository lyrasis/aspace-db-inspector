# ASpace DB Inspector

Pre-reqs:

- [Ruby](#)

```bash
sudo apt install libmysqlclient-dev
bundle install
```

Unless happy with the default config (`./config/settings.yml`) create:

```bash
cp config/settings.yml config/settings.local.yml
```

And set the database connection configuration as required.

## Setup

```bash
bundle exec rake connect # no output if connection is ok
bundle exec rake db:check_dates_dst
```
