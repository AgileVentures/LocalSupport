Feature: Site admins can propose edits to organisations' non public fields
As a site admin of HCN
So I can help the superadmin improve the accuracy of HCN
I want to be able to propose edits to inaccurate organisation listings, including to non published fields

  Background: organisations have been added to database
    Given the following organisations exist:
      | name              | description             | address        | postcode | telephone | website             | email                  | publish_email | publish_address | donation_info  | publish_phone |
      | Friendly          | Bereavement Counselling | 34 pinner road | HA1 4HZ  | 020800000 | http://friendly.org | superadmin@friendly.xx | false         |  false          | www.donate.com | false         |
      | Example           | Bereavement Counselling | 34 pinner road | HA1 4HZ  | 020800000 | http://friendly.org | superadmin@friendly.xx | true          |  true           | www.donate.com | true          |
    Given the following users are registered:
      | email                 | password | organisation        | confirmed_at         | superadmin | siteadmin |
      | siteadmin@example.com | pppppppp |                     | 2007-01-01  10:00:00 | false      | true      |
      | justauser@example.com | pppppppp |                     | 2007-01-01  10:00:00 | false      | false     |

   @vcr
   Scenario: Site admin sees fields marked as private
    Given I am signed in as a siteadmin
    And I visit the show page for the organisation named "Friendly"
    And I click "Propose an edit"
    Then the email field is marked private
    And the address field is marked private
    And the telephone field is marked private

  Scenario: Site admin sees fields marked as public
    Given I am signed in as a siteadmin
    And I visit the show page for the organisation named "Example"
    And I click "Propose an edit"
    Then the email field is marked public
    And the address field is marked public
    And the telephone field is marked public

  Scenario: Site admin proposes edit to non public fields
    Given I am signed in as a siteadmin
    And I visit the show page for the organisation named "Friendly"
    And I click "Propose an edit"
    And the telephone field of the proposed edit should be pre-populated with the telephone of the organisation named "Friendly"
    And the email field of the proposed edit should be pre-populated with the email of the organisation named "Friendly"
    And the address field of the proposed edit should be pre-populated with the address of the organisation named "Friendly"
    When I propose the following edit:
     | telephone  | address         | email    |
     | 520800000  | 30 pinner road  | a@a.com  |
    And I press "Propose this edit"
    Then "Friendly" should have the following proposed edits by user "siteadmin@example.com":
     | telephone  | address         | email    |
     | 520800000  | 30 pinner road  | a@a.com  |
    Then I should be on the show organisation proposed edit page for the organisation named "Friendly"
    And the following proposed edits should be displayed on the page:
     | field               | current value                 | proposed value     |
     | telephone           | 020800000                     | 520800000          |
     | email               | superadmin@friendly.xx        | a@a.com            |
     | address             | 34 pinner road                | 30 pinner road     |

  Scenario: User who is not site admin cannot see unpublished fields in proposed edit
    Given I am signed in as a non-siteadmin
    And the following proposed edits exist:
      | original_name       | editor_email                  | address        | telephone | email   |
      | Friendly            | siteadmin@example.com         | 30 pinner road | 520800000 | a@a.com |
    And I visit the most recently created proposed edit for "Friendly"
    Then I should not see the email field for Friendly
    Then I should not see the address field for Friendly
    Then I should not see the telephone field for Friendly

  Scenario: Super admin can see unpublished fields in proposed edit
    Given the following users are registered:
      | email                  | password | organisation        | confirmed_at         | superadmin | siteadmin |
      | superadmin@example.com | pppppppp |                     | 2007-01-01  10:00:00 | true       | false     |
    And the following proposed edits exist:
      | original_name          | editor_email                   | address              | telephone  | email   |
      | Friendly               | siteadmin@example.com          | 30 pinner road       | 520800000  | a@a.com |
    And I am signed in as an superadmin
    And I visit the most recently created proposed edit for "Friendly"
    Then the following proposed edits should be displayed on the page:
      | field          |  current value         | proposed value |
      | address        | 34 pinner road         | 30 pinner road |
      | telephone      | 020800000              | 520800000      |
      | email          | superadmin@friendly.xx | a@a.com        |
