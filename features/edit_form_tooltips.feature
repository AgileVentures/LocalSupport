Feature:  Tool tip instructions for fields on edit form
  As a charity owner
  So that I can fill out the edit form correctly
  I want to be able to have detailed tool tip instructions for edit form

  Tracker story ID: https://www.pivotaltracker.com/story/show/55198634

  Background:
    Given the following organizations exist:
      | name                            | description                      | address        | postcode | website       |
      | Harrow Bereavement Counselling  | Harrow Bereavement Counselling   | 34 pinner road | HA1 4HZ  | http://a.com/ |

    Given the following users are registered:
      | email                         | password | organization                    | confirmed_at |
      | registered_user-3@example.com | pppppppp | Harrow Bereavement Counselling  | 2007-01-01  10:00:00 |

  Scenario: Display tooltip for each label on the edit form
    Given I am signed in as a charity worker related to "Harrow Bereavement Counselling"
    And I am on the edit charity page for "Harrow Bereavement Counselling"
    #Then I should see "Name" < tagged > with "first tooltip"
    Then the "Name" label should display "Enter a unique name" as a tooltip

