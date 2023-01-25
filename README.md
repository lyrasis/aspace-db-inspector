# ASpace DB Inspector

```bash
sudo apt install libmysqlclient-dev
bundle install
bundle exec rake connect # no output if connection is ok
bundle exec rake db:check_dates_dst
```
