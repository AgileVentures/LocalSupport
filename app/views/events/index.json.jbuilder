json.array! @events do |event|
  date_format = event.all_day_event? ? '%d-%m-%Y' : '%d-%m-%YT%H:%M:%S'
  json.id event.id
  json.title event.title
  json.start event.start_date.strftime(date_format)
  json.end event.end_date.strftime(date_format)
end
