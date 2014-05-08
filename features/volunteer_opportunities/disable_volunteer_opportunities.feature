Feature: As a project manager
  I want to push the latest patches to production
  but I don't want the unfinished volunteer features to be visible to users
  so that we can work more quickly and efficiently with a single code base
  https://www.pivotaltracker.com/story/show/70846998

Background:
  Given the following organizations exist:
    | name                            | description                      | address        | postcode | website       |
    | Cats Are Us                     | Animal Shelter                   | 34 pinner road | HA1 4HZ  | http://a.com/ |
    | Indian Elders Association       | Care for the elderly             | 64 pinner road | HA1 4HA  | http://b.com/ |
  And the following users are registered:
    | email                      | password | organization | confirmed_at        | admin |
    | admin@cats.example.org     | pppppppp | Cats Are Us  | 2007-01-01 10:00:00 | false |
    | admin@shy.example.org      | pppppppp | Shy          | 2007-01-01 10:00:00 | false |
    | admin@harrowcn.org.uk      | pppppppp | Shy          | 2007-01-01 10:00:00 | true  |
  And the following volunteer opportunities exist:
    | title                           | description                        | organization              |
    | Litter Box Scooper              | Assist with feline sanitation      | Cats Are Us               |
    | Office Support                  | Help with printing and copying.    | Indian Elders Association |
  And the following feature flags exist:
    | name          | active |
    | volunteer_ops | true   |

  And cookies are approved
	
Scenario Outline: Top navbar links to Volunteers and Organisations are hidden when feature is disabled
  Given that the volunteer_ops flag is disabled
  And I visit the home page
  Then the navbar should not have a link to <link>
Examples:
  | link          |
  | Volunteers    |
  | Organisations |

Scenario Outline: Top navbar has links to Volunteers and Organisations when feature is enabled
  Given that the volunteer_ops flag is enabled
  And I visit the home page
  Then the navbar should have a link to <link>
Examples:
  | link          |
  | Volunteers    |
  | Organisations |

Scenario: Org-owners can see a Create Volunteer Opportunity button on their organization show page when feature is enabled
  Given that the volunteer_ops flag is enabled
  And I am signed in as a charity worker related to "Cats Are Us"
  And I am on the charity page for "Cats Are Us"
  Then I should see a link with text "Create a Volunteer Opportunity"

Scenario: Org-owners cannot see a Create Volunteer Opportunity button on their organization show page when feature is disabled
  Given that the volunteer_ops flag is disabled
  And I am signed in as a charity worker related to "Cats Are Us"
  And I am on the charity page for "Cats Are Us"
  Then I should not see a link with text "Create a Volunteer Opportunity"

Scenario: Volunteer Ops List Page should be inaccessible when feature is disabled
  Given that the volunteer_ops flag is disabled
  And I visit the volunteer opportunities page
  Then I should not see:
    | title                           | description                        | organization              |
    | Litter Box Scooper              | Assist with feline sanitation      | Cats Are Us               |
    | Office Support                  | Help with printing and copying.    | Indian Elders Association |

Scenario: Volunteer Ops List Page should be accessible when feature is enabled
  Given that the volunteer_ops flag is enabled
  And I visit the volunteer opportunities page
  Then I should see:
    | title                           | description                        | organization              |
    | Litter Box Scooper              | Assist with feline sanitation      | Cats Are Us               |
    | Office Support                  | Help with printing and copying.    | Indian Elders Association |