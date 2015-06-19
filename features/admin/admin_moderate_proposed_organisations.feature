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
      | registered_user-2@example.com | pppppppp | false        | 2007-01-01  10:00:00 |
      | registered_user-3@example.com | pppppppp | false        | 2007-01-01  10:00:00 |
    And a proposed organisation has been proposed by "registered_user-1@example.com"

  Scenario: Superadmin sees proposed organisation and buttons
    And I am signed in as an superadmin
    And I visit the proposed organisation show page for the proposed organisation that was proposed
    Then I should see an "Accept Proposed Organisation" button
    And I should see a "Reject Proposed Organisation" button

  Scenario: Superadmin accepts new organisation
    And I am signed in as an superadmin
    And I visit the proposed organisation show page for the proposed organisation that was proposed
    And I press "Accept"
    Then I should be on the show page for the organisation that was proposed
    And I should see "You have approved the following organisation"

  Scenario: Superadmin rejects new organisation
    And I am signed in as an superadmin
    And I visit the proposed organisation show page for the proposed organisation that was proposed
    And I press "Reject"
    Then I should be on the proposed organisations index page
    And the proposed organisation should have been rejected

  Scenario: Nonsigned in user does not see proposed organisation
    And I visit the proposed organisation show page for the proposed organisation that was proposed
    Then I should see "You don't have permission"
    And I should be on the home page

  Scenario: Random user does not see proposed organisation
    And I visit the home page
    And I sign in as "registered_user-2@example.com" with password "pppppppp"
    Then I should see a link or button "registered_user-2@example.com"
    And I visit the proposed organisation show page for the proposed organisation that was proposed
    Then I should see "You don't have permission"
    And I should be on the home page


  Scenario: Superadmin finds list of proposed organisations
    Given the following proposed organisations exist:
       |proposer_email                | name       | description             | address        | postcode | telephone | website               | email                    | donation_info        |
       |registered_user-2@example.com | Unfriendly | Mourning loved ones     | 30 pinner road | HA5 4HZ  | 520800000 | http://unfriendly.org | superadmin@unfriendly.xx | www.pleasedonate.com |
       |registered_user-3@example.com | Friendly   | Bereavement             | 30 pinner road | HA5 4HZ  | 520800000 | http://friendly.org   | superadmin@friendly.xx   | www.pleasedonate.com |
    And I am signed in as an superadmin
    And I visit the home page
    And I click on the all proposed organisations link
    Then I should see a view details link for each of the proposed organisations




