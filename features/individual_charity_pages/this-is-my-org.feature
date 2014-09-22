Feature: This is my organisation
  As a organisation administrator
  So that I could be set as an admin of our organisation (to edit details, post volunteer ops)
  I want to be able to request for the privilege through our organisation page

  Background:
    Given the following organisations exist:
      | name         | address        |
      | Helpful Folk | 83 pinner road |

    And the following users are registered:
      | email                  | password       | admin | confirmed_at        | organisation | pending_organisation |
      | nonadmin@myorg.com     | mypassword1234 | false | 2008-01-01 00:00:00 |              |                      |
      | pendingadmin@myorg.com | mypassword1234 | false | 2008-01-01 00:00;00 |              | Helpful Folk         |
      | admin@myorg.com        | mypassword1234 | true  | 2008-01-01 00:00:00 |              |                      |

    And cookies are approved

  Scenario: I am a signed in user who requests to be admin for my organisation
    Given I am signed in as a non-admin
    When I visit the show page for the organisation named "Helpful Folk"
    And I click "This is my organisation"
    Then I should be on the show page for the organisation named "Helpful Folk"
    And "nonadmin@myorg.com"'s request status for "Helpful Folk" should be updated appropriately
    And an email should be sent to "admin@myorg.com" as notification of request

    # at a really high level <-- this is comparable to the feature description
    # Given I am signed in as a non-admin
    # When I request admin status for "Helpful Folk"   <-- clicks on TIMO link, stays on page
    # Then "nonadmin@myorg.com"'s request status for "Helpful Folk" should be updated appropriately <-- request persisted in db, flash alert, TIMO button removed
    # And an email should be sent to "admin@myorg.com" as notification of request


# when capybara-webkit clicks TIMO, it needs to submit sign in form with javascript or
# else ClickFailed error will occur due to overlapping elements
  @javascript
  Scenario: I am not signed in, I will be offered "This is my organisation" claim button
    When I visit the show page for the organisation named "Helpful Folk"
    Then I should see "This is my organisation"
    When I click id "TIMO"
    Then I should be on the show page for the organisation named "Helpful Folk"
    When I sign in as "nonadmin@myorg.com" with password "mypassword1234" with javascript
    Then I should see "You have requested admin status for Helpful Folk"
    Then I should be on the show page for the organisation named "Helpful Folk"
    And "nonadmin@myorg.com"'s request status for "Helpful Folk" should be updated appropriately

  @javascript
  Scenario: I sign in incorrectly once and then sign in successfully after pressing TIMO
    When I visit the show page for the organisation named "Helpful Folk"
    Then I should see "This is my organisation"
    When I click id "TIMO"
    Then I should be on the show page for the organisation named "Helpful Folk"
    When I sign in as "nonadmin@myorg.com" with password "mypassword1235" with javascript
    Then I should be on the sign in page
    When I sign in as "nonadmin@myorg.com" with password "mypassword1234"
    Then I should see "You have requested admin status for Helpful Folk"
    Then I should be on the show page for the organisation named "Helpful Folk"
    And "nonadmin@myorg.com"'s request status for "Helpful Folk" should be updated appropriately
    And an email should be sent to "admin@myorg.com" as notification of request

  @javascript
  Scenario: I am not a registered user, I will be offered "This is my organisation" claim button
    When I visit the show page for the organisation named "Helpful Folk"
    Then I should see "This is my organisation"

  @javascript
  Scenario: I am not a registered user and I claim this is my organisation
    When I visit the show page for the organisation named "Helpful Folk"
    When I click id "TIMO"
    When I click "toggle_link"
    And I sign up as "normal_user@myorg.com" with password "pppppppp" and password confirmation "pppppppp"
    And I should see "A message with a confirmation link has been sent to your email address. Please open the link to activate your account."
    Then I should be on the show page for the organisation named "Helpful Folk"
    And "normal_user@myorg.com"'s request for "Helpful Folk" should be persisted
    And I should see "You have requested admin status for Helpful Folk"

  @javascript
  Scenario: I am not a registered user and I sign up incorrectly and then correctly after pressing TIMO
    When I visit the show page for the organisation named "Helpful Folk"
    Then I should see "This is my organisation"
    When I click id "TIMO"
    When I click "toggle_link"
    And I sign up as "newuser@myorg.com" with password "pppppppp" and password confirmation "qppppppp"
    Then I should see "error"
    And I sign up as "newuser@myorg.com" with password "pppppppp" and password confirmation "pppppppp" on the legacy sign up page
    And I should see "A message with a confirmation link has been sent to your email address. Please open the link to activate your account."
    Then I should be on the show page for the organisation named "Helpful Folk"

  Scenario: I have requested admin status but am not yet approved, I will see a notice on the show page
    Given I visit the home page
    And I sign in as "pendingadmin@myorg.com" with password "mypassword1234"
    And I visit the show page for the organisation named "Helpful Folk"
    Then I should see "Your request for admin status is pending."
