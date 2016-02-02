Feature: As a member of the public
  So that I can make contact with an organisation about volunteering
  I would like ot see more details about a volunteer opportunity

  Background:
    Given the following organisations exist:
      | name                      | description          | address        | postcode | website       |
      | Cats Are Us               | Animal Shelter       | 34 pinner road | HA1 4HZ  | http://a.com/ |
      | Indian Elders Association | Care for the elderly | 64 pinner road | HA1 4HZ  | http://b.com/ |
    Given the following volunteer opportunities exist:
      | title              | description                                     | organisation              |
      | Litter Box Scooper | Assist with feline sanitation   test@test.com   | Cats Are Us               |
      | Office Support     | Help with printing and copying. http://test.com | Indian Elders Association |

  @vcr
  Scenario: See a volunteer opportunity and hyperlink
    Given I visit the show page for the volunteer_op titled "Office Support"
    Then I should see:
      | title          | description                     | organisation              |
      | Office Support | Help with printing and copying. | Indian Elders Association |
    And I click "Indian Elders Association"
    Then I should be on the show page for the organisation named "Indian Elders Association"

  Scenario: See URLs in volunteer opportunity pages are hyperlinked
    Given I visit the show page for the volunteer_op titled "Office Support"
    Then the page includes a hyperlink to "http://test.com"

  Scenario: See emails in volunteer opportunity pages are hyperlinked
    Given I visit the show page for the volunteer_op titled "Litter Box Scooper"
    Then the page includes email hyperlink "test@test.com"
