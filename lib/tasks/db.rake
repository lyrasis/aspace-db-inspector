# frozen_string_literal: true

namespace :db do
  task :connect do
    ActiveRecord::Base.establish_connection(Settings.database.to_h)
    ActiveRecord::Base.connection.tables
  end

  task :check_dates_dst, %i[] => :connect do |_t, _args|
    find_columns_for_type('datetime').each do |table, datetime|
      query = ActiveRecord::Base.sanitize_sql_array(
        ['SELECT id, %s FROM `%s` WHERE MONTH(%s) = 3 AND HOUR(%s) = 2', datetime.name, table, datetime.name,
         datetime.name]
      )
      results = ActiveRecord::Base.connection.execute(query)
      next unless results.any?

      results.each do |row|
        id, result = row
        result_date = result.to_datetime unless result.nil?
        next if result_date.nil?
        next unless suspicious_date?(result_date)

        puts [table, datetime.name, id, result_date, result_date.year, result_date.month, result_date.hour].to_csv
      end
    end
  end

  private

  # probably some other way to get this ... ???
  def dst_year_to_day_of_march
    {
      2009 => 8,
      2010 => 14,
      2011 => 13,
      2012 => 11,
      2013 => 10,
      2014 => 9,
      2015 => 8,
      2016 => 13,
      2017 => 12,
      2018 => 11,
      2019 => 10,
      2020 => 8,
      2021 => 14,
      2022 => 13,
      2023 => 12
    }
  end

  def find_columns_for_type(type)
    Enumerator.new do |yielder|
      ActiveRecord::Base.connection.tables.each do |table|
        ActiveRecord::Base.connection.columns(table).each do |column|
          yielder << [table, column] if column.sql_type == type
        end
      end
    end
  end

  def suspicious_date?(date)
    dst_day = dst_year_to_day_of_march[date.year]
    date.month == 3 && date.day == dst_day && date.hour == 2
  end
end
