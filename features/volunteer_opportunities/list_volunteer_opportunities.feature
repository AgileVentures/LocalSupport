Feature: As a member of the public
  So that I can find out where I can volunteer my time
  I would like to see a list of volunteer opportunities
  Tracker story ID: https://www.pivotaltracker.com/story/show/66059724

  Background: organisations with volunteer opportunities have been added to database

    Given the following organisations exist:
      | name                      | description          | address        | postcode | website       |
      | Cats Are Us               | Animal Shelter       | 34 pinner road | HA1 4HZ  | http://a.com/ |
      | Indian Elders Association | Care for the elderly | 64 pinner road | HA1 4HZ  | http://b.com/ |
    Given the following volunteer opportunities exist:
      | title              | description                     | organisation              |
      | Litter Box Scooper | Assist with feline sanitation   | Cats Are Us               |
      | Office Support     | Help with printing and copying. | Indian Elders Association |

  @vcr
  Scenario: See a list of current volunteer opportunities
    Given I visit the volunteer opportunities page
    And cookies are approved
    Then the index should contain:
    | Litter Box Scooper              | Assist with feline sanitation      | Cats Are Us               |
    | Office Support                  | Help with printing and copying.    | Indian Elders Association |
  Scenario: Volunteer index page has two column layout
    Given I visit the volunteer opportunities page
    Then I should see a two column layout

  Scenario Outline: Top navber has link to Organisations
    Given I visit the home page
    Then the navbar should have a link to <link>
    Examples:
      | link |
      | Organisations |

  Scenario Outline: Top navbar links to Volunteers are hidden when feature is disabled
    Given that the volunteer_ops_list flag is disabled
    And I visit the home page
    Then the navbar should not have a link to <link>
    Examples:
      | link          |
      | Volunteers    |

  Scenario Outline: Top navbar has links to Volunteers when feature is enabled
    Given that the volunteer_ops_list flag is enabled
    And I visit the home page
    Then the navbar should have a link to <link>
    Examples:
      | link          |
      | Volunteers    |
