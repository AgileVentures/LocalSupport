Feature: Categories of charities
  As a member of the public, or local charity worker
  In order to find a particular type of service
  I want to navigate through categories to find service
  Tracker story ID: https://www.pivotaltracker.com/story/show/46217161

  Background: organisations have been added to database
    Given the following organisations exist:
      | name                  | description                    | address        | postcode | website       |
      | I love dogs           | loves canines                  | 34 pinner road | HA1 4HZ  | http://a.com/ |
      | I love cats           | loves felines                  | 64 pinner road | HA1 4HA  | http://b.com/ |
      | I hate animals        | hates birds and beasts         | 84 pinner road | HA1 4HF  | http://c.com/ |
      | I help people         | helps people with disabilities | 30 pinner road | HA1 4HF  | http://c.com/ |
      | I advocate for people | helps people by advocating     | 83 pinner road | HA1 4HF  | http://c.com/ |

    And the following categories exist:
      | name                     | charity_commission_id |
      | Animal Welfare           | 101                   |
      | Plant Welfare            | 102                   |
      | Animals with plants      | 201                   |
      | People with disabilities | 202                   |
      | Watering                 | 301                   |
      | Advocacy                 | 303                   |

    And the following categories_organisations exist:
      | category                 | organisation          |
      | Animal Welfare           | I love dogs           |
      | Animal Welfare           | I love cats           |
      | People with disabilities | I help people         |
      | Advocacy                 | I advocate for people |

  Scenario: Search for organisations in the "Animal Welfare" category
  #Given I have at least 3 organisations in the "Animal Welfare" category
    Given I visit the home page
    And cookies are approved
    And I select the "Animal Welfare" category from What They Do
    And I press "Submit"
    Then I should see "I love dogs"
    And I should not see "I hate animals"

    # TODO must ensure this also works with searching for text so we can search within a category
  Scenario: Search for dogs in the Animal Welfare category
    Given I visit the home page
    And I select the "Animal Welfare" category from What They Do
    And I search for "dogs"
    Then I should see "I love dogs"
    And I should not see "I love cats"
    And I should not see "I hate animals"

  Scenario: Search for doges when selected categories exclude I love dogs
    Given I visit the home page
    And I select the "Plant Welfare" category from What They Do
    And I select the "Advocacy" category from How They Help
    And I select the "People with disabilities" category from Who They Help
    And I search for "dogs"
    And I should not see "I love dogs"

  Scenario: Search for organisations in the "People with disabilities" category
    Given I visit the home page
    And I select the "People with disabilities" category from Who They Help
    And I press "Submit"
    Then I should see "I help people"
    And I should not see "I hate animals"

  Scenario: Search for organisations in the "Advocacy" category
    Given I visit the home page
    And I select the "Advocacy" category from How They Help
    And I press "Submit"
    Then I should see "I advocate for people"
    And I should not see "I hate animals"

  Scenario: Even organisations without categories are returned when All is selected for all dropdowns
  #Given I have at least 3 organisations in the "Animal Welfare" category
    Given I visit the home page
    And cookies are approved
    And I press "Submit"
    Then I should see "I hate animals"

