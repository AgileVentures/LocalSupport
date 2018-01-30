class NewsletterEventsJob
  class << self
    include Rails.application.routes.url_helpers
    def create_campaign
      # TODO: create campaign on mailchimp using the updated list (https://github.com/amro/gibbon#campaigns)
      #Testing if push will do
      # The mailchimp campaign it will list all Events with a link to each of them and
      # when it will have place, eg.:
      #
      # Dear Colleagues,
      #
      # This email contains a list of upcoming events and training sessions.
      #
      # Simply scan the list below and click the relevant session(/s) right for you.
      #
      # Introduction To Monitoring & Evaluation
      # Friday, 12th January 2018, 12pm to 3pm
      #                 .
      #                 .
      #                 .
      #                 .
      # Comic Relief Local Communities - Core Strength Programme Workshop
      # Monday, 15th January 2018, 9.30am to 12.30pm
    end

    def organisation_emails
      Organisation.pluck(:email, :name).reduce([]) do |emails, data|
        # There are organisations that don't have the email configured
        emails << { data[0] => data[1] } unless data[0].empty?
        emails
      end
    end

    def events
      Event.where('start_date >= ?', Date.today).reduce([]) do |data, event|
        data << format_event(event)
      end
    end

    def format_event(event)
      date = event.start_date
      start_date = date.strftime("%A, #{date.day.ordinalize} %B %Y, %l%P")
      {
          title: event.title,
          date: "#{start_date} #{event.end_date.strftime('to %I%P')}",
          url: "https://www.harrowcn.org.uk#{event_path(event.id)}"
      }
    end

    def update_list
      # TODO: update list (using list_id and the gibbon gem) with the collected emails
    end
  end
end
