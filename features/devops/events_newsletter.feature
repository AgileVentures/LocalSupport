Feature: Charity admin can send a newsletter with upcoming events
  As a charity admin
  So that I can increase awareness of our activities
  I would like a newsletter emailed out with upcoming events

  Background: Events have been added to the database

    Given the following events exist:
      | title               | description       | start_date          | end_date            |
      | My first event      | Good for everyone | 2030-10-20 10:30:14 | 2030-10-20 17:00:00 |
      | Open Source Weekend | Good for everyone | 2030-10-20 10:30:14 | 2030-10-20 17:00:00 |
      | Lazy Weekend        | Also good         | 2055-02-02 08:00:00 | 2055-02-02 17:00:00 |
    And the following users are registered:
      | email                   | password           | superadmin | confirmed_at        | organisation    | pending_organisation |
      | nonsuperadmin@myorg.com | mypassword1234     | false      | 2008-01-01 00:00:00 |                 |                      |
      | superadmin@myorg.com    | superadminpass0987 | true       | 2008-01-01 00:00:00 | My Organisation |                      |


  Scenario: Automated task delivers event newsletter email
    When the events newsletter task runs
    Then I should see email delivered from "support@harrowcn.org.uk"
    And I should see "Upcoming events updates" in the email subject
    # And I should see "Open Source Weekend" in the email body
    #And I should see "Lazy Weekend" in the email body

