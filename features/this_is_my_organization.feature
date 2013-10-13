Feature: This is my organization
  As a organization administrator
  So that I could be set as an admin of our organization
  I want to be able to request for the privilege through our organization page

  Background:
    Given the following organizations exist:
    | name            | address        |
    | My Organization | 83 pinner road |

    And the following users are registered:
    | email              | password       | admin | confirmed_at        | organization    | charity_admin_pending |
    | nonadmin@myorg.com | mypassword1234 | false | 2008-01-01 00:00:00 |                 | false                 |
    | admin@myorg.com    | adminpass0987  | true  | 2008-01-01 00:00:00 | My Organization | false                 |
    | pending@myorg.com  | password123    | false | 2008-01-01 00:00:00 |                 | true                  |

  Scenario: I am an user who has not signed in and requests to be admin of my organization
    Given I am not signed in as any user
    And I am on the charity page for "My Organization"
    Then I should see the "This is my organization" button for "My Organization"
    When I press "This is my organization"
    Then I should be on the sign in page
    When I sign in as "nonadmin@myorg.com" with password "mypassword1234"
    Then an email should be sent to "admin@myorg.com"
    And I should see "You have requested admin status for My Organization"
    And I should be on the charity page for "My Organization"
    And I should not see the "This is my organization" button for "My Organization"

    
  Scenario: I am a signed in user who requests to be admin for my organization
    Given I am on the sign in page
    And I sign in as "nonadmin@myorg.com" with password "mypassword1234"
    When I am on the charity page for "My Organization"
    And I press "This is my organization"
    Then I should be on the charity page for "My Organization"
    And I should see "You have requested admin status for My Organization"
    And an email should be sent to "admin@myorg.com"
    # And flags listed below must be set for user
    # user.charity_admin_pending will be set to TRUE here
    # user.pending_organization_id is set for their charity
    
    # when the admin signs in, they should see the users who want rights
  Scenario: I am an admin checking out list of users who want edit privileges for an organization
    Given I am signed in as an admin
    And "pending@myorg.com" has requested admin status for "My Organization"
    When I am on the users page
    Then I should see "Users awaiting approval"
    And I should see "Organization"
    And I follow "Users awaiting approval"
    Then I should see "pending@myorg.com"
    And I should not see "nonadmin@myorg.com"
    And I should see "My Organization"
    And I should see a link to approve "pending@myorg.com"
    #(what about can_edit?)
    
  Scenario: I am an admin checking out list of all users
    Given I am signed in as an admin
    And "pending@myorg.com" has requested admin status for "My Organization"
    When I am on the users page
    And I follow "All users"
    Then I should see "pending@myorg.com"
    Then I should see "nonadmin@myorg.com"
    And I should not see a link to approve "nonadmin@myorg.com"
    And I should not see a link to approve "admin@myorg.com"

  Scenario: I am not an admin but I am sneaky and not signed in
    Given I am not signed in as any user
    When I am on the users page
    Then I should be on the sign in page
    And I should see "You must be signed in as admin to perform that action!"

  Scenario: I am not an admin but I am sneaky and signed in as non-admin
    Given I am signed in as a non-admin
    When I am on the users page
    Then I should be on the home page
    And I should see "You must be signed in as admin to perform that action!"
