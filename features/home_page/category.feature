Feature: Categories of charities
  As a member of the public, or local charity worker
  In order to find a particular type of service
  I want to navigate through categories to find service
  Tracker story ID: https://www.pivotaltracker.com/story/show/46217161

  Background: organisations have been added to database
    Given the following organisations exist:
      | name                  | description                    | address        | postcode | website       |
      | I love dogs           | loves canines                  | 34 pinner road | HA1 4HZ  | http://a.com/ |
      | I love cats           | loves felines                  | 64 pinner road | HA1 4HZ  | http://b.com/ |
      | I hate animals        | hates birds and beasts         | 84 pinner road | HA1 4HZ  | http://c.com/ |
      | I help people         | helps people with disabilities | 30 pinner road | HA1 4HZ  | http://c.com/ |
      | I advocate for people | helps people by advocating     | 83 pinner road | HA1 4HZ  | http://c.com/ |
      | Dogs watering plants  | it just makes sense            | 34 pinner road | HA1 4HZ  | http://a.com/ |

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
      | Animals with plants      | I love dogs           |
      | Animals with plants      | Dogs watering plants  |
      | People with disabilities | I help people         |
      | Watering                 | Dogs watering plants  |
      | Advocacy                 | I love dogs           |
      | Advocacy                 | I advocate for people |

    And I visit the home page

  @vcr
  Scenario: Search for organisations in the "Animal Welfare" category
    Given I select the "Animal Welfare" category from What They Do
    And I press "Submit"
    Then I should see "I love dogs"
    And I should not see "I hate animals"

  Scenario: Search for organisations in both Animal Welfare and Animals with plants categories
    Given I select the "Animal Welfare" category from What They Do
    And I select the "Animals with plants" category from Who They Help
    And I press "Submit"
    Then I should see "I love dogs"
    And I should not see "I love cats"

  Scenario: Search for organisations in Advocacy, Animal Welfare and Animals with plants categories
    Given I select the "Animal Welfare" category from What They Do
    And I select the "Animals with plants" category from Who They Help
    And I select the "Advocacy" category from How They Help
    And I press "Submit"
    Then I should see "I love dogs"
    And I should not see "I love cats"
    And I should not see "I advocate for people"

    # TODO must ensure this also works with searching for text so we can search within a category
  Scenario: Search for dogs in the Animal Welfare category
    Given I select the "Animal Welfare" category from What They Do
    And I search for "dogs"
    Then I should see "I love dogs"
    And I should not see "I love cats"
    And I should not see "I hate animals"

  Scenario: Search for doges when selected categories exclude I love dogs
    Given I select the "Plant Welfare" category from What They Do
    And I select the "Advocacy" category from How They Help
    And I select the "People with disabilities" category from Who They Help
    And I search for "dogs"
    And I should not see "I love dogs"

  Scenario: Search for organisations in the "People with disabilities" category
    Given I select the "People with disabilities" category from Who They Help
    And I press "Submit"
    Then I should see "I help people"
    And I should not see "I hate animals"

  Scenario: Search for organisations in the "Advocacy" category
    Given I select the "Advocacy" category from How They Help
    And I press "Submit"
    Then I should see "I advocate for people"
    And I should not see "I hate animals"

  Scenario: Even organisations without categories are returned when All is selected for all dropdowns
    Given I press "Submit"
    Then I should see "I hate animals"

  Scenario: Using category dropselects to successively filter the results
    Given I select the "Animals with plants" category from Who They Help
    And I press "Submit"
    Then the organisation results should contain:
      | Dogs watering plants  |
      | I love dogs           |
    Then the organisation results should not contain:
      | I love cats           |
      | I hate animals        |
      | I help people         |
      | I advocate for people |
    And I select the "Watering" category from How They Help
    And I press "Submit"
    Then the organisation results should contain:
      | Dogs watering plants  |
    Then the organisation results should not contain:
      | I love dogs           |
      | I love cats           |
      | I hate animals        |
      | I help people         |
      | I advocate for people |

  Scenario: Categories are sticky
    Given I select the "Plant Welfare" category from What They Do
    And I select the "Advocacy" category from How They Help
    And I select the "People with disabilities" category from Who They Help
    And I press "Submit"
    Then the "Plant Welfare" category should be selected from What They Do
    Then the "Advocacy" category should be selected from How They Help
    Then the "People with disabilities" category should be selected from Who They Help

  Scenario: All values stay as default if not changed
    Given I press "Submit"
    Then the default all value should be selected from What They Do
    Then the default all value should be selected from Who They Help
    Then the default all value should be selected from How They Help
