Feature: As a member of the public
  So that I can make contact with an organization about volunteering
  I would like ot see more details about a volunteer opportunity

  Background:
    Given the following organizations exist:
      | name                      | description          | address        | postcode | website       |
      | Cats Are Us               | Animal Shelter       | 34 pinner road | HA1 4HZ  | http://a.com/ |
      | Indian Elders Association | Care for the elderly | 64 pinner road | HA1 4HA  | http://b.com/ |
    Given the following volunteer opportunities exist:
      | title              | description                     | organization              |
      | Litter Box Scooper | Assist with feline sanitation   | Cats Are Us               |
      | Office Support     | Help with printing and copying. | Indian Elders Association |

  Scenario: See a volunteer opportunity
    Given I visit the show page for the volunteer_op titled "Office Support"
    Then I should see:
      | title          | description                     | organization              |
      | Office Support | Help with printing and copying. | Indian Elders Association |