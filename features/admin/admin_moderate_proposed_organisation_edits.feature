Feature: Members of HCN may propose edits to organisations
  As the site superadmin for the Harrow Community Network
  So I can improve the accuracy of HCN and to save time
  I want to be able to moderate proposed edits to organisations listed on the HCN

  Background: organisations have been added to database
    Given the following organisations exist:
      | name              | description             | address        | publish_address | postcode | telephone | website             | email             | publish_phone |donation_info  | publish_email |
      | Friendly          | Bereavement Counselling | 30 pinner road | true            |HA1 4HZ   | 020800000 | http://friendly.org | superadmin@friendly.xx | true          |www.donate.com | true          |
      | Newness           | Bereavement Counselling | 30 pinner road | false           |HA1 4HZ   | 020800000 | http://friendly.org | superadmin@friendly.xx | false         | www.donate.com| false         |
    And the following users are registered:
      | email                         | password | organisation   | confirmed_at         | superadmin | siteadmin |
      | registered_user-2@example.com | pppppppp |                | 2007-01-01  10:00:00 | false      | false     |
      | superadmin@harrowcn.org.uk    | pppppppp |                | 2007-01-01  10:00:00 | true       | false     |
      | siteadmin@harrowcn.org.uk     | pppppppp |                | 2007-01-01  10:00:00 | false      | true      |
    And the following proposed edits exist:
      |original_name | editor_email                  | name       | description             | address        | postcode | telephone | website               | email                    | donation_info        | archived|
      |Friendly      | registered_user-2@example.com | Unfriendly | Mourning loved ones     | 30 pinner road | HA1 4HZ  | 520800000 | http://unfriendly.org | superadmin@unfriendly.xx | www.pleasedonate.com | false   |
      |Friendly      | registered_user-2@example.com | Unfriendly | Mourning loved ones     | 30 pinner road | HA1 4HZ  | 520800000 | http://unfriendly.org | superadmin@unfriendly.xx | www.pleasedonate.com | true    |

    And cookies are approved

  @vcr
  Scenario: Nonsuperadmins do not see pending proposed edits link
    Given I am signed in as an non-superadmin
    And I visit the home page
    Then I should not see the pending proposed edits link

  Scenario: Moderate a proposed edit
    Given I am signed in as a superadmin
    And I visit the home page
    And I click on the pending proposed edits link
    And I should not see links for archived edits
    And I click on view details for the proposed edit for the organisation named "Friendly"
    And I should see a link or button "Accept Edit"
    And I should see a link or button "Keep Current Information"

  Scenario: Editability is enforced at moderate time even if it has changed since proposal of edit
    Given I am signed in as a superadmin
    And the following proposed edits exist:
      |original_name | editor_email                  | name       | description             | address        | postcode | telephone | website               | email               | donation_info        | archived|
      |Newness       | registered_user-2@example.com | Unfriendly | Mourning loved ones     | 34 pinner road | HA1 4HZ  | 420800000 | http://unfriendly.org | stuff@unfriendly.xx | www.pleasedonate.com | false   |
    And I visit the most recently created proposed edit for "Newness"
    When I press "Accept Edit"
    Then I should be on the show page for the organisation named "Unfriendly"
    And the organisation named "Unfriendly" should have fields as follows:
     |address         | telephone | email             |
     | 30 pinner road | 020800000 | superadmin@friendly.xx |
  Scenario: Accept a proposed edit
    Given I am signed in as a superadmin
    And I visit the most recently created proposed edit for "Friendly"
    When I press "Accept Edit"
    Then I should be on the show page for the organisation named "Unfriendly"
    And "Friendly" should be updated as follows:
    | name       | description         | address        | postcode | telephone | website               | email               | donation_info               |
    | Unfriendly | Mourning loved ones | 30 pinner road | HA1 4HZ  | 520800000 | http://unfriendly.org | superadmin@unfriendly.xx | http://www.pleasedonate.com |
    And the most recently updated proposed edit for "Unfriendly" should be updated as follows:
      | archived | accepted |
      | true     | true     |
    And I should see "The edit you accepted has been applied and archived"

  @vcr
  Scenario: Accept a proposed edit from a siteadmin edits nonpublic fields
    Given I am signed in as a superadmin
    And the following proposed edits exist:
      |original_name | editor_email                  | name       | description             | address        | postcode | telephone | website               | email               | donation_info        | archived|
      |Newness       | siteadmin@harrowcn.org.uk     | Unfriendly | Mourning loved ones     | 34 pinner road | HA1 4HZ  | 420800000 | http://unfriendly.org | stuff@unfriendly.xx | www.pleasedonate.com | false   |
    And I visit the most recently created proposed edit for "Newness"
    When I press "Accept Edit"
    Then "Newness" should be updated as follows:
      | name             | description             | address        | postcode | telephone | website               | email               | donation_info               |
      | Unfriendly       | Mourning loved ones     | 34 pinner road | HA1 4HZ  | 420800000 | http://unfriendly.org | stuff@unfriendly.xx | http://www.pleasedonate.com |
  Scenario: Reject a proposed edit
    Given I am signed in as a superadmin
    And I visit the most recently created proposed edit for "Friendly"
    When I press "Keep Current Information"
    Then I should be on the show page for the organisation named "Friendly"
    And the most recently updated proposed edit for "Friendly" should be updated as follows:
      | archived | accepted |
      | true     | false    |
    And I should see "The edit you rejected has been archived"
