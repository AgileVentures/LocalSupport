Feature: Post volunteer ops to doit platform
  As a superadmin
  I would like to post volunteer opportunities to Doit
  Tracker story ID: https://www.pivotaltracker.com/story/show/139801559

  Background: organisations with volunteer opportunities have been added to database

    Given the following organisations exist:
      | name                      | description          | address        | postcode | website       |
      | Cats Are Us               | Animal Shelter       | 34 pinner road | HA1 4HZ  | http://a.com/ |
      | Indian Elders Association | Care for the elderly | 64 pinner road | HA1 4HZ  | http://b.com/ |
    And the following users are registered:
      | email                         | password | organisation | confirmed_at        | superadmin |
      | admin@example.com | pppppppp | Cats Are Us| 2007-01-01  10:00:00 |   true |
      | registered-user-1@example.com | pppppppp | Cats Are Us  | 2007-01-01 10:00:00 | false |
    And the following volunteer opportunities exist:
      | title              | description                     | organisation              |
      | Litter Box Scooper | Assist with feline sanitation   | Cats Are Us               |
      | Office Support     | Help with printing and copying. | Indian Elders Association |

  @vcr @javascript
  Scenario: Superadmin can post to Doit
    Given I am signed in as a superadmin
    And I visit the show page for the volunteer_op titled "Office Support"
    And I click "Publish to Doit"
    And I fill additional fields required by Doit
    And I press "Publish to Doit"
    Then I should see "Volunteer opportunity was published successfully to Doit"

  Scenario: Organisation admin can't publish to Doit
    Given I am signed in as a charity worker related to "Cats Are Us"
    And I visit the show page for the volunteer_op titled "Litter Box Scooper"
    Then I should not see a link with text "Publish to Doit"

