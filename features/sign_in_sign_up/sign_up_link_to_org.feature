Feature: If new user's email matches an org's email, the new user with have edit powers for that org
  As a new user
  So that I can quickly start editing the page for my org
  I want to automatically have editing powers if I sign up with an email address that matches my org
  Tracker story ID: https://www.pivotaltracker.com/story/show/50085485

  Background:
    Given the following organisations exist:
      | name           | description             | address        | postcode | telephone | email             |
      | Friendly       | Bereavement Counselling | 34 pinner road | HA1 4HZ  | 020800000 | info@friendly.org |
    And cookies are approved

  @vcr
  Scenario: Sign up and CANNOT edit
    Given I visit the sign up page
    And I sign up as "tester@friendly.org" with password "12345678" and password confirmation "12345678"
    And I sign in as "tester@friendly.org" with password "12345678" via email confirmation
    And I visit the show page for the organisation named "Friendly"
    Then I should not see an edit button for "Friendly" charity

  Scenario: Sign up and can edit
    Given I visit the sign up page
    And I sign up as "info@friendly.org" with password "12345678" and password confirmation "12345678"
    And I sign in as "info@friendly.org" with password "12345678" via email confirmation
    And I visit the show page for the organisation named "Friendly"
    Then I should see an edit button for "Friendly" charity

# https://github.com/plataformatec/devise/wiki/How-To:-Override-confirmations-so-users-can-pick-their-own-passwords-as-part-of-confirmation-activation
# do_confirm @ ConfirmationController: all it does is call .confirm!, which is publicly available ...
# http://rubydoc.info/github/plataformatec/devise/master/Devise/Models/Confirmable
# Thus, to simulate a user returning with a valid email token, we can just call confirm! on them
