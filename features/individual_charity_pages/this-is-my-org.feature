Feature: This is my organization
  As a organization administrator
  So that I could be set as an admin of our organization
  I want to be able to request for the privilege through our organization page

  Background:
    Given the following users are registered:
       | email              | password       | admin | confirmed_at        | organization |
       | nonadmin@myorg.com | mypassword1234 | false | 2008-01-01 00:00:00 |              |
    And the following organizations exist:
       | name             | address        |
       | The Organization | 83 pinner road |
    And cookies are approved

  Scenario: I am a signed in user who requests to be admin for my organization
    Given I am signed in as a non-admin 
    When I am on the charity page for "The Organization"
    Then I should see a link or button "This is my organization"
    And I click "This is my organization"
    Then I should be on the charity page for "The Organization"
    And "nonadmin@myorg.com"'s request status for "The Organization" should be updated appropriately

  # Happiest path: user successfully logs in with a confirmed login
  Scenario: I am not signed in, I will be offered "This is my organization" claim button
    When I am on the charity page for "The Organization"
    Then I should see "This is my organization"
    When I click "This is my organization"
    Then I should be on the Sign in page
    When I sign in as "nonadmin@myorg.com" with password "pppppppp"
    Then I should be on the charity page for "The Organization"

  Scenario: I am not a registered user, I will be offered "This is my organization" claim button
    When I am on the charity page for "The Organization"
    Then I should see "This is my organization"
    When I click "This is my organization"
    Then I should be on the Sign in page
    When I sign up as "normal_user@myorg.com" with password "pppppppp" and password confirmation "pppppppp"
    Then I should be on the charity page for "The Organization"
    And "normal_user@myorg.com"'s request status for "The Organization" should be updated appropriately

  # User has a login, not confirmed
  # User has no login, signs up successfully
  # User has no login, fails to sign up
