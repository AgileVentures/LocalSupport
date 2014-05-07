Feature: Admin creating charity
  As a Admin
  So that I can add new charities to the site)
  I want to be able to create new charities

  Background: organizations have been added to database
    Given the following organizations exist:
      | name           | description             | address        | postcode | telephone |
      | Friendly       | Bereavement Counselling | 34 pinner road | HA1 4HZ  | 020800000 |
      | Friendly Clone | Quite Friendly!         | 30 pinner road | HA1 4HZ  | 020800010 |
    And the following users are registered:
      | email                         | password | admin | confirmed_at         | organization |
      | registered-user-1@example.com | pppppppp | true  | 2007-01-01  10:00:00 | Friendly     |
      | registered-user-2@example.com | pppppppp | false | 2007-01-01  10:00:00 |              |
    And cookies are approved

  Scenario: Unsuccessfully attempt to create charity without being signed-in
      # should this be checking for absence of link to the new org page?
    Given I visit the new organisation page
    Then I should be on the sign in page

# beta version only allows admin to create new organization, currently
# we only show link to admin, and are waiting on proper enforcement feature
# TODO get scenario as following commented one

  #Scenario: Unsuccessfully attempt to create charity when signed-in as non-admin
    ## should this be checking for absence of link to the new org page?
    #Given I am signed in as a non-admin
    #Given I visit the new organisation page
    #Then I should be on the sign in page

  Scenario: Successfully create charity while being signed-in as admin
    Given I am signed in as a admin
    And I have created a new organization
    Then I should see "Organization was successfully created."

  Scenario: Successfully create charity while being signed-in as admin from arbitrary page
    Given I am signed in as a admin
    Given I visit the show page for the organization named "Friendly Clone"
    And I follow "New Organisation"
    And I fill in the new charity page validly
    And I press "Create Organisation"
    Then I should see "Organization was successfully created."

  Scenario: Non-admin unsuccessfully attempts to create an organization
    Given I am signed in as a non-admin
    And I create "Unwanted" org
    Then I should be on the organisations index page
    Then I should see permission denied
    And I should not see "Organization was successfully created."
    And "Unwanted" org should not exist

  Scenario: non logged in user should not see new organization link
    Given I visit the home page
    Then I should not see a new organizations link

  Scenario: logged in non-admin user should not see new organization link
    Given I am signed in as a non-admin
    Given I visit the home page
    Then I should not see a new organizations link
