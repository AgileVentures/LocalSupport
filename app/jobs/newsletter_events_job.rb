class NewsletterEventsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # TODO: collect all organisation emails
    #
    # TODO: collect all events from this month to the end of the year
    #
    # TODO: update list (using list_id and the gibbon gem) with the collected emails
    #
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
end
