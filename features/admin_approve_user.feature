Feature: Admin approve user
  As an Admin
  So that I can approve someone to be able to make edits for a particular charity
    (either by sending a verification e-mail to an e-mail address we know is
     connected to the relevant charity, when someone contacts us saying that
     this is his charity or when a new charity wants to be included on the database)
  I want to be able to verify the organisation/user and give them access to their charity.

  Background:
    Given the following users are registered:
    | email              | password       | admin | confirmed_at        | organization    |
    | nonadmin@myorg.com | mypassword1234 | false | 2008-01-01 00:00:00 |                 |
    | admin@myorg.com    | adminpass0987  | true  | 2008-01-01 00:00:00 | My Organization |

    And the following organizations exist:
    | name            | address        |
    | My Organization | 83 pinner road |

  Scenario: Admin receives user request for edit priveleges for a charity
    Given I am signed in as admin
    And a user has requested edit privileges for "My Organization"
    Then I should receive a "A user has requested edit privileges for My Organization" email 

  Scenario: Admin approves user request for edit priveleges for a charity
    Given I am on the home page
    And I am signed in as admin
    And a user has requested edit privileges for "My Organization"
    Then I should see "Users awaiting approval"
    And I should see "nonadmin@myorg.com"
    When I follow edit_user_path(nonadmin@myorg.com)
    And approve "nonadmin@myorg.com" to edit "My Organization"
    Then "nonadmin@myorg.com" can edit "My Organization"
    

  Scenario: Admin does not approve user request for edit priveleges for a charity
    Given I am on the home page
    And I am signed in as admin
    And a user has requested edit privileges for "My Organization"
    Then I should see "Users awaiting approval"
    And I should see "nonadmin@myorg.com"
    When I follow edit_user_path(nonadmin@myorg.com)
    And do not approve "nonadmin@myorg.com" to edit "My Organization"
    Then "nonadmin@myorg.com" can not edit "My Organization"

  Scenario: NonAdmin can not approve user request for edit priveleges for a charity
    Given I am on the home page
    And I am signed in as nonadmin
    And a user has requested edit privileges for "My Organization"
    Then I should not see "Users awaiting approval"
    And I should not see "nonadmin@myorg.com"
