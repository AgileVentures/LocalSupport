Feature: As a project manager
  I want to push the latest patches to production
  but I don't want the volunteer epic code to be visible to users
  so that we can work more quickly and efficiently with a single code base
  https://www.pivotaltracker.com/story/show/70846998
	
Scenario Outline: Top navbar links to Volunteers and Organisations are hidden 
  Given that the volunteer_ops flag is disabled
  And I visit the home page
  Then the navbar should not have a link to <link>
Examples:
  | link          |
  | Volunteers    |
  | Organisations |

Scenario Outline: Top navbar has links to Volunteers and Organisations 
  Given that the volunteer_ops flag is enabled
  And I visit the home page
  Then the navbar should have a link to <link>
Examples:
  | link          |
  | Volunteers    |
  | Organisations |
