Given /^today's date is (\d{4}-\d{2}-\d{2})$/ do |date_string|
  Timecop.travel(Date.strptime(date_string, '%Y-%m-%d'))
end