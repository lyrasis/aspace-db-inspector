# frozen_string_literal: true

require 'active_record'
require 'active_record_simple_execute'
require 'config'
require 'csv'

Rake.add_rakelib 'lib/tasks'

task default: %w[db:connect]

Config.load_and_set_settings(Config.setting_files('./config', 'development'))
