class NewsletterEventsJob
  class << self
    def create_campaign
      # TODO: create campaign on mailchimp using the updated list (https://github.com/amro/gibbon#campaigns)
      #
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
      emails = []
      Organisation.pluck(:email, :name).each do |email, name|
        # There are organisations that don't have the email configured
        emails << { email => name } unless email.empty?
      end
      emails
    end

    def events
      # TODO: collect all events from this month to the end of the year
    end

    def update_list
      # TODO: update list (using list_id and the gibbon gem) with the collected emails
    end
  end
end
