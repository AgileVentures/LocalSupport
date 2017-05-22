Feature: Super Admin creating charity
  As a Super Admin
  So that I can add new charities to the site)
  I want to be able to create new charities

  Background: organisations have been added to database
    Given the following organisations exist:
      | name           | description             | address        | postcode | telephone |
      | Friendly       | Bereavement Counselling | 34 pinner road | HA1 4HZ  | 020800000 |
      | Friendly Clone | Quite Friendly!         | 30 pinner road | HA1 4HZ  | 020800010 |
    And the following users are registered:
      | email                         | password | superadmin | confirmed_at         | organisation |
      | registered-user-1@example.com | pppppppp | true  | 2007-01-01  10:00:00 | Friendly     |
      | registered-user-2@example.com | pppppppp | false | 2007-01-01  10:00:00 |              |
    And the following categories exist:
      | name              | charity_commission_id |
      | Animal welfare    | 101                   |
      | Child welfare     | 102                   |
      | Feed the hungry   | 103                   |
      | Accommodation     | 203                   |
      | General           | 204                   |
      | Health            | 202                   |
      | Education         | 303                   |
      | Give them things  | 304                   |
      | Teach them things | 305                   |

    And cookies are approved

  @vcr
  Scenario: Unsuccessfully attempt to create charity without being signed-in
    # should this be checking for absence of link to the new org page?
    Given I visit the new organisation page
    Then I should be on the sign in page

    # beta version only allows superadmin to create new organisation, currently
    # we only show link to superadmin, and are waiting on proper enforcement feature
    # TODO get scenario as following commented one

    #Scenario: Unsuccessfully attempt to create charity when signed-in as non-superadmin
    ## should this be checking for absence of link to the new org page?
    #Given I am signed in as a non-superadmin
    #Given I visit the new organisation page
    #Then I should be on the sign in page

  @vcr
  Scenario: Successfully create charity while being signed-in as superadmin
    Given I am signed in as a superadmin
    And I have created a new organisation
    Then I should see "Organisation was successfully created."

  @vcr
  Scenario: Get validation error creating new charity with invalid url while being signed-in as superadmin
    Given I am signed in as a superadmin
    And I visit the home page
    And I follow "New Organisation"
    And I fill in the new charity page with an invalid website
    And I press "Create Organisation"
    Then I should see "Website is not a valid URL"

  @vcr
  Scenario: Get validation error creating new charity with empty fields while being signed-in as superadmin
    Given I am signed in as a superadmin
    And I visit the home page
    And I follow "New Organisation"
    And I press "Create Organisation"
    Then I should see "Name can't be blank"
    Then I should see "Description can't be blank"
    
  @vcr   
  Scenario: After getting validation error when creating new organisation checked categories are still visible
    Given I am signed in as a superadmin
    And I visit the home page
    And I follow "New Organisation"
    And I check the category "Child welfare"
    And I check the category "Health"
    And I press "Create Organisation"
    Then the category named Child welfare should be checked
    Then the category named Health should be checked

  @vcr
  Scenario: Successfully create charity while being signed-in as superadmin from arbitrary page
    Given I am signed in as a superadmin
    Given I visit the show page for the organisation named "Friendly Clone"
    And I follow "New Organisation"
    And I fill in the new charity page validly including the categories:
      | name           |
      | Feed the hungry|
      | Accommodation  |
    And I press "Create Organisation"
    Then I should see "Organisation was successfully created."
    And I should see "Feed the hungry"
    And I should see "Accommodation"
    And I should not see "General" within "org-categories"

  Scenario: Non-superadmin unsuccessfully attempts to create an organisation
    Given I am signed in as a non-superadmin
    And I create "Unwanted" org
    Then I should be on the organisations index page
    Then I should see permission denied
    And I should not see "Organisation was successfully created."
    And "Unwanted" org should not exist

  Scenario: non logged in user should not see new organisation link
    Given I visit the home page
    Then I should not see a new organisations link

  Scenario: logged in non-superadmin user should not see new organisation link
    Given I am signed in as a non-superadmin
    Given I visit the home page
    Then I should not see a new organisations link
