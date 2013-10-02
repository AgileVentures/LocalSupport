Feature: This is my organization
  As a organization administrator
  So that I could be set as an admin of our organization
  I want to be able to request for the privilege through our organization page

  Background:
    Given the following users are registered:
    | email              | password       | admin | confirmed_at        | organization    | charity_admin_pending |
    | nonadmin@myorg.com | mypassword1234 | false | 2008-01-01 00:00:00 |                 | false                 |
    | admin@myorg.com    | adminpass0987  | true  | 2008-01-01 00:00:00 | My Organization | false                 |
    | pending@myorg.com  | password123    | false | 2008-01-01 00:00:00 | My Organization | true                  |

    And the following organizations exist:
    | name            | address        |
    | My Organization | 83 pinner road |

  Scenario: I am a guest user who signs up to be admin of my organization
    Given I am not signed in as any user
    When I am on the charity page for "My Organization"
    And I press "This is my organization"
    Then I should be on the sign in page
    When I sign in as "nonadmin@myorg.com" with password "mypassword1234"
    Then I should see "You have requested admin status on My Organization"
    And an email should be sent to "admin@myorg.com"

    
  Scenario: I am a signed in user who requests to be admin of my organization
    Given I am signed in as a non-admin
    When I am on the charity page for "My Organization"
    And I press "This is my organization"
    Then I should be on the charity page for "My Organization"
    And I should see "You have requested admin status on My Organization"
    And an email should be sent to "admin@myorg.com"
    # And flags listed below must be set for user
    # user.charity_admin_pending will be set to TRUE here
    # user.organization is set for their charity
    
    # when the admin signs in, they should see the users who want rights
  Scenario: I am an admin checking out list of users who want edit privileges for an organization
    Given I am signed in as an admin
    When I am on the users page
    And I should see "Users awaiting approval"
    #And I should see "Organizations"
    #TODO - add organization column
    And I follow "Users awaiting approval"
    Then I should see a list of users with pending privileges
    And I should see a link to approve them
    #(what about can_edit?)

  Scenario: I am not an admin but I am sneaky and not signed in
    Given I am not signed in as any user
    When I go to the users page
    Then I should be redirected to the sign in page

  Scenario: I am not an admin but I am sneaky and signed in as non-admin
    Given I am signed in as a non-admin
    When I go to the users page
    Then I should be redirected to sign in as admin