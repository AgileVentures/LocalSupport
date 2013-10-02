Feature: This is my organization
  As a organization administrator
  So that I could be set as an admin of our organization
  I want to be able to request for the privilege through our organization page

  Background:
    Given the following users are registered:
    | email              | password       | admin | confirmed_at        | organization    |
    | nonadmin@myorg.com | mypassword1234 | false | 2008-01-01 00:00:00 |                 |
    | admin@myorg.com    | adminpass0987  | true  | 2008-01-01 00:00:00 | My Organization |

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
    # And flags listed below must be set for user
    # user.charity_admin_pending will be set to true here
    # user.can_edit must be FALSE
    # user.organization is NIL or ""

    #I can sign in or sign up from here
    
  Scenario: I am a signed in user who requests to be admin of my organization
    Given I am signed in as a non-admin
    When I am on the charity page for "My Organization"
    And I press "This is my organization"
    Then I should be on the charity page for "My Organization"
    And I should see "You have requested admin status on My Organization"
    And an email should be sent to "admin@myorg.com"
    # And flags listed below must be set for user
    # user.charity_admin_pending will be set to TRUE here
    # user.can_edit must be FALSE
    # user.organization is set for their charity

    # NEW SCENARIO
    # user was approved by admin
        # user.can_edit must be TRUE (which means they are charity admin for that org)
        # user.charity_admin_pending will be FALSE (changed from true)
        # user.organization is still set for their charity
    # behavior-wise user should be able to see Edit button on their org
    # user should not be able to see Edit button on other organizations
  Scenario: I am now a charity admin
    Given I am approved as a charity admin
    # (port something like this to the admin_approve_user.feature for the background step?)
    And I am on the charity page for "My Organization"
    Then I should see an edit button for "My Organization" charity
    When I am on the charity page for "Another organization"
    Then I should not see an edit button for "Another organization" charity

    
    
