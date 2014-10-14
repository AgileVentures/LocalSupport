Feature: Categories of charities
  As a member of the public, or local charity worker
  In order to find a particular type of service
  I want to navigate through categories to find service
  Tracker story ID: https://www.pivotaltracker.com/story/show/46217161

  Background: organisations have been added to database
    Given the following organisations exist:
      | name              | description              | address        | postcode | website       |
      | I love dogs       | loves canines            | 34 pinner road | HA1 4HZ  | http://a.com/ |
      | I love cats       | loves felines            | 64 pinner road | HA1 4HA  | http://b.com/ |
      | I hate animals    | hates birds and beasts   | 84 pinner road | HA1 4HF  | http://c.com/ |

    And the following categories exist:
      | name              | charity_commission_id |
      | Animal Welfare    | 101                   |
      | Health            | 102                   |
      | Education         | 103                   |

    And the following categories_organisations exist:
      | category |  organisation |
      | Animal Welfare | I love dogs |
      | Animal Welfare | I love cats |

  Scenario: Search for organisations in the "Animal Welfare" category
  #Given I have at least 3 organisations in the "Animal Welfare" category
    Given I visit the home page
    And I select the "Animal Welfare" category
    And I press "Submit"
    Then I should see "I love dogs"
    And I should not see "I hate animals"

    # TODO must ensure this also works with searching for text so we can search within a category
  Scenario: Search for dogs in the Animal Welfare category
    Given I visit the home page
    And I select the "Animal Welfare" category
    And I search for "dogs"
    Then I should see "I love dogs"
    And I should not see "I love cats"
    And I should not see "I hate animals"
