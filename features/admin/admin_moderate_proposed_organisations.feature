Feature: Admin moderates an organisation to be added to HarrowCN
  As a superadmin
  So that I can allow easier access to HCN for organisations
  I want to moderate proposed organisations to be added to HCN
  Tracker story ID: https://www.pivotaltracker.com/story/show/742821

  Background: 

    Given the following users are registered:
      | email                         | password | superadmin   | confirmed_at         |
      | superadmin@example.com        | pppppppp | true         | 2007-01-01  10:00:00 |
      | registered_user-1@example.com | pppppppp | false        | 2007-01-01  10:00:00 |
    And a proposed organisation has been proposed by "registered_user-1@example.com"

  Scenario:
    And I am signed in as an superadmin
    And I visit the proposed organisation show page for the proposed organisation that was proposed
    Then I should see an "Accept Proposed Organisation" button
    And I should see a "Reject Proposed Organisation" button




