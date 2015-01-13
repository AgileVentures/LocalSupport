Feature: Members of HCN may propose edits to organisations
  As the site admin for the Harrow Community Network
  So I can improve the accuracy of HCN and to save time
  I want to be able to moderate proposed edits to organisations listed on the HCN

  Background: organisations have been added to database
    Given the following organisations exist:
      | name              | description             | address        | postcode | telephone | website             | email             | publish_phone | publish_address | donation_info  |
      | Friendly          | Bereavement Counselling | 34 pinner road | HA1 4HZ  | 020800000 | http://friendly.org | admin@friendly.xx | true          |  false          | www.donate.com |
    And the following users are registered:
      | email                         | password | organisation        | confirmed_at         | admin |
      | registered_user-2@example.com | pppppppp |                     | 2007-01-01  10:00:00 | false |
      | admin@harrowcn.org.uk         | pppppppp |                     | 2007-01-01  10:00:00 | true  |
    And the following proposed edits exist:
      |original_name | editor_email                  | name     | description             | address        | postcode | telephone | website             | email             | donation_info  |
      |Friendly      | registered_user-2@example.com | Friendly | Mourning loved ones     | 34 pinner road | HA1 4HZ  | 020800000 | http://friendly.org | admin@friendly.xx | www.donate.com |
    And cookies are approved

  Scenario: Nonadmins do not see all proposed edits link
    Given I am signed in as an non-admin
    And I visit the home page
    Then I should not see the all proposed edits link
  Scenario: Moderate a proposed edit
    Given I am signed in as an admin
    And I visit the home page
    And I click on the all proposed edits link
    And I click on view details for the proposed edit for the organisation named "Friendly"
    Then I should see the accept edit button
    And I should see the reject edit button
