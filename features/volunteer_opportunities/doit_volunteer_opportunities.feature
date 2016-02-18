Feature: As a member of the public
  So that I can see where organisations with volunteer opportunities are located
  I would like to see a map of do-it volunteer opportunities

  @javascript @vcr @billy
  Scenario: See a map of current doit volunteer opportunities
    Given that the doit_volunteer_opportunities flag is enabled
    And I visit the volunteer opportunities page
    And cookies are approved
    And I should see 17 markers in the map

  @javascript @vcr @billy
  Scenario: See a map of current doit and harrow volunteer opportunities
    Given the following organisations exist:
      | name                      | description          | address        | postcode | website       |
      | Cats Are Us               | Animal Shelter       | 34 pinner road | HA1 4HZ  | http://a.com/ |
      | Indian Elders Association | Care for the elderly | 64 pinner road | HA1 4HZ  | http://b.com/ |
    Given the following users are registered:
      | email                         | password | organisation | confirmed_at         |
      | registered_user-1@example.com | pppppppp | Cats Are Us  | 2007-01-01  10:00:00 |
    Given the following volunteer opportunities exist:
      | title              | description                     | organisation              |
      | Litter Box Scooper | Assist with feline sanitation   | Cats Are Us               |
      | Office Support     | Help with printing and copying. | Indian Elders Association |
    Given that the doit_volunteer_opportunities flag is enabled
    And I visit the volunteer opportunities page
    And cookies are approved
    And I should see 19 markers in the map

    @javascript @vcr @billy
    Scenario: See a list of current doit volunteer opportunities with a link to  organisation page
      Given that the doit_volunteer_opportunities flag is enabled
      Given I visit the volunteer opportunities page
      And cookies are approved
      Then the index should contain:
      | Scout Leader (volunteering with 10-14 year olds) 27th Harrow              | By Volunteering to work with scouts, you will be responsible, along with the other leaders, helpers and members for planning and running the weekly ...    | Scouts - Scout Association - Greater London Region               |
      Then I should see a link to "Scouts - Scout Association - Greater London Region" page "https://do-it.org/organisations/greater-london-region"

    @javascript @vcr @billy
    Scenario: See a list of current doit volunteer opportunities with a link to opportunity page
      Given that the doit_volunteer_opportunities flag is enabled
      Given I visit the volunteer opportunities page
      And cookies are approved
      Then the index should contain:
      | Scout Leader (volunteering with 10-14 year olds) 27th Harrow              | By Volunteering to work with scouts, you will be responsible, along with the other leaders, helpers and members for planning and running the weekly ...    | Scouts - Scout Association - Greater London Region               |
      Then I should see a link to "Scout Leader (volunteering with 10-14 year olds) 27th Harrow" page "https://do-it.org/opportunities/79ae1022-9059-40c0-82dd-3f5b15dd796a" 

    @javascript @vcr @billy
    Scenario: Doit volunteer opportunites are listed in map popups
      Given that the doit_volunteer_opportunities flag is enabled
      Given I visit the volunteer opportunities page
      And cookies are approved
      And the map should show the do-it opportunity titled Fundraising Officer for Age UK in Harrow



