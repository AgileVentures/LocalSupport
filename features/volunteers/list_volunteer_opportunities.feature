Feature: As a member of the public
  So that I can find out where I can volunteer my time
  I would like to see a list of volunteer opportunities
  Tracker story ID: https://www.pivotaltracker.com/story/show/66059724

Background: organizations with volunteer opportunities have been added to database
  
  Given the following organizations exist:
  | name                            | description                      | address        | postcode | website       |
  | Cats Are Us                     | Animal Shelter                   | 34 pinner road | HA1 4HZ  | http://a.com/ |
  | Indian Elders Association       | Care for the elderly             | 64 pinner road | HA1 4HA  | http://b.com/ |
  Given the following volunteer opportunities exist:
  | title                           | description                        | organization              |
  | Litter Box Scooper              | Assist with feline sanitation      | Cats Are Us               |
  | Office Support                  | Help with printing and copying.    | Indian Elders Association | 

@javascript
Scenario:  
    Given I am on the home page
    Then I should see Litter Box Scooper
    And I should see Office Support
