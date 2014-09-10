Feature: This is my organisation
  As a organisation administrator
  So that I could be set as an admin of our organisation
  I want to be able to request for the privilege through our organisation page

  Background:
    Given the following users are registered:
       | email              | password       | admin | confirmed_at        | organisation |
       | nonadmin@myorg.com | mypassword1234 | false | 2008-01-01 00:00:00 |              |
    And the following organisations exist:
       | name             | address        |
       | The Organisation | 83 pinner road |
    And cookies are approved

  Scenario: I am a signed in user who requests to be admin for my organisation
    Given I am signed in as a non-admin 
    When I visit the show page for the organisation named "The Organisation"
    Then I should see a link or button "This is my organisation"
    And I click "This is my organisation"
    Then I should be on the show page for the organisation named "The Organisation"
    And "nonadmin@myorg.com"'s request status for "The Organisation" should be updated appropriately

  @javascript
  Scenario: I am not signed in, I will be offered "This is my organisation" claim button
    When I visit the show page for the organisation named "The Organisation"
    Then I should see "This is my organisation"
    When I click id "TIMO"
    Then I should be on the show page for the organisation named "The Organisation"
    When I sign in as "nonadmin@myorg.com" with password "mypassword1234"
    Then I should see "You have requested admin status for The Organisation"
    Then I should be on the show page for the organisation named "The Organisation"
    And "nonadmin@myorg.com"'s request status for "The Organisation" should be updated appropriately

  @javascript
  Scenario: I sign in incorrectly once and then sign in successfully after pressing TIMO
    When I visit the show page for the organisation named "The Organisation"
    Then I should see "This is my organisation"
    When I click id "TIMO"
    Then I should be on the show page for the organisation named "The Organisation"
    When I sign in as "nonadmin@myorg.com" with password "mypassword1235"
    Then I should be on the sign in page
    When I sign in as "nonadmin@myorg.com" with password "mypassword1234"
    Then I should see "You have requested admin status for The Organisation"
    Then I should be on the show page for the organisation named "The Organisation"
    And "nonadmin@myorg.com"'s request status for "The Organisation" should be updated appropriately

  @javascript
  Scenario: I am not a registered user, I will be offered "This is my organisation" claim button
    When I visit the show page for the organisation named "The Organisation"
    Then I should see "This is my organisation"
    When I click id "TIMO"
    When I click "toggle_link"
    And I sign up as "normal_user@myorg.com" with password "pppppppp" and password confirmation "pppppppp"
    Then I should be on the home page
    And I should see "A message with a confirmation link has been sent to your email address. Please open the link to activate your account."
