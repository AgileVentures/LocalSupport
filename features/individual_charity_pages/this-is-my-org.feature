Feature: This is my organisation
  As an organisation administrator
  So that I could be set as a admin of our organisation (to edit details, post volunteer ops)
  I want to be able to request for the privilege through our organisation page

  Background:
    Given the following organisations exist:
      | name         | description    | address        | postcode |
      | Helpful Folk | Amazing team   | 83 pinner road | HA1 4HZ  |
      | The Other    | Awesome people | 83 pinner road | HA1 4HZ  |

    And the following users are registered:
      | email                       | password       | superadmin | confirmed_at        | organisation | pending_organisation |
      | admin@helpfolk.com          | mypassword1234 | false      | 2008-01-01 00:00:00 |              |                      |
      | pendingadmin@helpfolk.com   | mypassword1234 | false      | 2008-01-01 00:00;00 |              | Helpful Folk         |
      | superadmin@localsupport.org | mypassword1234 | true       | 2008-01-01 00:00:00 |              |                      |

    And cookies are approved

  @vcr
  Scenario: Signed in User
    Given I am signed in as a non-superadmin
    And I click "This is my organisation" on the "Helpful Folk" page and stay there
    Then I should see "You have requested admin status for Helpful Folk"
    And I should not see a link or button "This is my organisation"
    And "admin@helpfolk.com"'s request for "Helpful Folk" should be persisted
    And an email should be sent to "superadmin@localsupport.org" as notification of the request for admin status of "Helpful Folk"

# when capybara-webkit clicks TIMO, it needs to submit sign in form with javascript or
# else ClickFailed error will occur due to overlapping elements
  @javascript @billy
  Scenario: Not Signed in User
    Given I click "This is my organisation" on the "Helpful Folk" page and stay there
    When I sign in as "admin@helpfolk.com" with password "mypassword1234" with javascript
    Then I should see "You have requested admin status for Helpful Folk"
    And I should not see a link or button "This is my organisation"
    And "admin@helpfolk.com"'s request for "Helpful Folk" should be persisted
    And an email should be sent to "superadmin@localsupport.org" as notification of the request for admin status of "Helpful Folk"

# what we're not checking here is that the login box pops open with the right message
# I think we cover that in jasmine tests - needed here too?
  @javascript @billy
  Scenario: Not Signed in User Who Fails Signin Once
    Given I click "This is my organisation" on the "Helpful Folk" page and stay there
    When I sign in as "admin@helpfolk.com" with password "mypassword1235" with javascript
    Then I should be on the sign in page
    When I sign in as "admin@helpfolk.com" with password "mypassword1234"
    Then I should see "You have requested admin status for Helpful Folk"
    And I should not see a link or button "This is my organisation"
    And "admin@helpfolk.com"'s request for "Helpful Folk" should be persisted
    And an email should be sent to "superadmin@localsupport.org" as notification of the request for admin status of "Helpful Folk"

  @vcr @javascript @billy
  Scenario: Unregistered User
    Given I click "This is my organisation" on the "Helpful Folk" page and stay there
    And I click "toggle_link"
    When I sign up as "normal_user@myorg.com" with password "pppppppp" and password confirmation "pppppppp"
    Then I should see "A message with a confirmation link has been sent to your email address. Please open the link to activate your account."
    And I should be on the show page for the organisation named "Helpful Folk"
    Then I should see "You have requested admin status for Helpful Folk"
    # And I should not see a link or button "This is my organisation"  <-- button still appears as we have no current_user ...
    And "normal_user@myorg.com"'s request for "Helpful Folk" should be persisted
    And I click on the confirmation link in the email to "normal_user@myorg.com"
    When I sign in as "normal_user@myorg.com" with password "pppppppp" on the legacy sign in page
    Then I should be on the show page for the organisation named "Helpful Folk"
    And an email should be sent to "superadmin@localsupport.org" as notification of the request for admin status of "Helpful Folk"

  @javascript @billy
  Scenario: Unregistered User Who Fails Signin Once
    Given I click "This is my organisation" on the "Helpful Folk" page and stay there
    When I click "toggle_link"
    And I sign up as "newuser@myorg.com" with password "pppppppp" and password confirmation "qppppppp"
    Then I should see "Password confirmation doesn't match Password"
    And I sign up as "newuser@myorg.com" with password "pppppppp" and password confirmation "pppppppp" on the legacy sign up page
    And I should see "A message with a confirmation link has been sent to your email address. Please open the link to activate your account."
    And I should be on the show page for the organisation named "Helpful Folk"
    Then I should see "You have requested admin status for Helpful Folk"
    # And I should not see a link or button "This is my organisation"  <-- button still appears as we have no current_user ...
    And "newuser@myorg.com"'s request for "Helpful Folk" should be persisted
    And I click on the confirmation link in the email to "newuser@myorg.com"
    When I sign in as "newuser@myorg.com" with password "pppppppp" on the legacy sign in page
    Then I should be on the show page for the organisation named "Helpful Folk"
    And an email should be sent to "superadmin@localsupport.org" as notification of the request for admin status of "Helpful Folk"

  Scenario: I have requested admin status but am not yet approved, I will see a notice only on the show page for the requested org
    Given I am signed in as a pending admin of "Helpful Folk"
    And I visit the show page for the organisation named "Helpful Folk"
    Then I should see "Your request for admin status is pending."
    And I visit the show page for the organisation named "The Other"
    Then I should not see "Your request for admin status is pending."
