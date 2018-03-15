namespace :newsletter_events do
  desc 'Create monthly campaign on MailChimp'
  task :create_campaign do
    date = Time.zone.today
    NewsletterEventsJob.create_campaign if date == date.beginning_of_month
  end
end
