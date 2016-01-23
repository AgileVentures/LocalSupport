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
    And I am signed in as an superadmin

  @vcr
  Scenario: Superadmin sees proposed organisation and buttons
    And I visit the proposed organisation show page for the proposed organisation that was proposed
    Then I should see an "Accept Proposed Organisation" button
    And I should see a "Reject Proposed Organisation" button

  @vcr
  Scenario: Superadmin accepts new organisation
    And I visit the proposed organisation show page for the proposed organisation that was proposed
    And I press "Accept"
    Then I should be on the show page for the organisation that was proposed
    And I should see "You have approved the following organisation"

  @vcr
  Scenario: Registered user is notified when superadmin accepts proposed organisation
    Given the following proposed organisations exist:
      | name       | description             | address        | postcode | telephone | website               | email                         | donation_info        | non_profit |
      | Unfriendly | Mourning loved ones     | 30 pinner road | HA5 4HZ  | 520800000 | http://unfriendly.org | registered_user-1@example.com | www.pleasedonate.com | true       |
    And I accept the proposed_organisation named "Unfriendly"
    And an email should be sent to "registered_user-1@example.com" as notification of the acceptance of proposed organisation "Unfriendly"
    And "registered_user-1@example.com" is an organisation admin of "Unfriendly"
    And I should see "A notification of acceptance was sent to registered_user-1@example.com"

  @vcr
  Scenario: Unregistered user is invited when superadmin accepts proposed organisation
    Given the following proposed organisations exist:
      | name       | description             | address        | postcode | telephone | website               | email                      | donation_info        | non_profit |
      | Unfriendly | Mourning loved ones     | 30 pinner road | HA5 4HZ  | 520800000 | http://unfriendly.org | unregistered@unfriendly.xx | www.pleasedonate.com | true       |
    And having accepted the proposed organisation named "Unfriendly", I see "An invitation email was sent to unregistered@unfriendly.xx"
    And an invitational email should be sent to "unregistered@unfriendly.xx" as notification of the acceptance of proposed organisation "Unfriendly"
    And "unregistered@unfriendly.xx" is an organisation admin of "Unfriendly"
    And I click on the invitation link in the proposed org accepted email to "unregistered@unfriendly.xx"
    And I set my password
    Then I should be on the show page for the organisation named "Unfriendly"

  @vcr
  Scenario: Invalid email garners message when superadmin accepts proposed organisation
    Given the following proposed organisations exist:
      | name       | description             | address        | postcode | telephone | website               | email    | donation_info        | non_profit |
      | Unfriendly | Mourning loved ones     | 30 pinner road | HA5 4HZ  | 520800000 | http://unfriendly.org |  xyt     | www.pleasedonate.com | true       |
    And having accepted the proposed organisation named "Unfriendly", I see "No invitation email was sent because the email associated with Unfriendly, xyt, seems invalid"

  @vcr
  Scenario: Blank email garners message when superadmin accepts proposed organisation
    Given the following proposed organisations exist:
      | name       | description             | address        | postcode | telephone | website               | email    | donation_info        | non_profit |
      | Unfriendly | Mourning loved ones     | 30 pinner road | HA5 4HZ  | 520800000 | http://unfriendly.org |          | www.pleasedonate.com | true       |
    And having accepted the proposed organisation named "Unfriendly", I see "No invitation email was sent because no email is associated with the organisation"

  @vcr
  Scenario: Superadmin rejects new organisation
    And I visit the proposed organisation show page for the proposed organisation that was proposed
    And I press "Reject"
    Then I should be on the proposed organisations index page
    And the proposed organisation should have been rejected

  @vcr
  Scenario: Superadmin finds list of proposed organisations
    Given the following proposed organisations exist:
      |proposer_email                | name       | description             | address        | postcode | telephone | website               | email                    | donation_info        | non_profit |
      |registered_user-2@example.com | Unfriendly | Mourning loved ones     | 30 pinner road | HA1 4HZ  | 520800000 | http://unfriendly.org | superadmin@unfriendly.xx | www.pleasedonate.com | true       |
      |registered_user-3@example.com | Friendly   | Bereavement             | 30 pinner road | HA1 4HZ  | 520800000 | http://friendly.org   | superadmin@friendly.xx   | www.pleasedonate.com | true       |
    And I visit the home page
    And I click on the pending proposed organisations link
    Then I should see a view details link for each of the proposed organisations

  @vcr
  Scenario: Superadmin views details of proposed organisations
    And the following categories exist:
      | name                     | charity_commission_id |
      | Animal Welfare           | 101                   |
      | Plant Welfare            | 102                   |
      | Animals with plants      | 201                   |
      | People with disabilities | 202                   |
      | Watering                 | 301                   |
      | Advocacy                 | 303                   |
    And the proposed organisations have the categories:
      | category                 | proposed_organisation |
      | Animal Welfare           | Friendly Charity      |
      | Plant Welfare            | Friendly Charity      |
      | Animals with plants      | Friendly Charity      |
      | People with disabilities | Friendly Charity      |
      | Watering                 | Friendly Charity      |
      | Advocacy                 | Friendly Charity      |
    And I visit the proposed organisation show page for the proposed organisation that was proposed
    Then I should see the details of the proposed organisation
    And I should see the following:
      | Animal Welfare           |
      | Plant Welfare            |
      | Animals with plants      |
      | People with disabilities |
      | Watering                 |
      | Advocacy                 |
