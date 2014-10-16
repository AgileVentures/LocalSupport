Feature: Charity worker can edit own charity profile
  As a charity worker
  So that I can increase my charity's visibility
  I want to edit my charity's web page (description and contact details)
  Tracker story ID: https://www.pivotaltracker.com/story/show/45671099

#address of nice must be 30 pinner road because of change the address of charity scenario
#need to revisit this
Background: organisations have been added to database 
  Given the following organisations exist:
  | name           | description               | address        | postcode | telephone | email              |
  | Friendly       | Bereavement Counselling   | 34 pinner road | HA1 4HZ  | 020800000 | admin@friendly.org |
  | Nice           | Quite Pleasant!           | 30 pinner road | HA1 4HZ  | 020800010 | admin@nice.org     |
  
  Given the following users are registered:
  | email                         | password | organisation | confirmed_at         |
  | registered_user-2@example.com | pppppppp | Friendly     | 2007-01-01  10:00:00 |
  | registered_user-1@example.com | pppppppp |              | 2007-01-01  10:00:00 |
  And cookies are approved

Given the following categories exist:
  | name              | charity_commission_id |
  | Animal welfare    | 101                   |
  | Child welfare     | 102                   |
  | Feed the hungry   | 103                   |
  | Accommodation     | 203                   |
  | General           | 204                   |
  | Health            | 202                   |
  | Education         | 303                   |
  | Give them things  | 304                   |
  | Teach them things | 305                   |
Given the following categories_organisations exist:
  | category  |  organisation |
  | Health    | Friendly      |
  | Education | Friendly      |

Scenario: Successfully add website url without protocol
  Given I am signed in as a charity worker related to "Friendly"
  And I update "Friendly" charity website to be "www.friendly.com"
  Then the website link for "Friendly" should have a protocol

Scenario: Successfully change the address of a charity
  Given I am signed in as a charity worker related to "Friendly"
  And I update "Friendly" charity address to be "30 pinner road"
  Then I should be on the show page for the organisation named "Friendly"

Scenario Outline: Successfully mark a field of a charity as public or private
  Given I am signed in as a charity worker related to "Friendly"
  And I visit the edit page for the organisation named "Friendly"
  And the <field> for "Friendly" has been marked hidden
  And I <check_state> "<field_checkbox>"
  And I press "Update Organisation"
  Then I should be on the show page for the organisation named "Friendly"
  And I should <visibility> "<field_contents>"
  And I should <visibility> "<field_label>"
Examples:
  | field     | field_checkbox               | field_contents      | field_label | check_state | visibility |
  | phone     | organisation_publish_phone   | 020800000           | Telephone   | check       | see        |
  | address   | organisation_publish_address | 34 pinner road      | Address     | check       | see        |
  | email     | organisation_publish_email   | admin@friendly.org  | Email       | check       | see        |
  | phone     | organisation_publish_phone   | 020800000           | Telephone   | uncheck     | not see    |
  | address   | organisation_publish_address | 34 pinner road      | Address     | uncheck     | not see    |
  | email     | organisation_publish_email   | admin@friendly.org  | Email       | uncheck     | not see    |


#TODO refactor into integration test that posts to update method
#Scenario: Unsuccessfully change the address of a charity
#  Given I am signed in as a charity worker unrelated to "Friendly"
#  Given I furtively update "Friendly" charity address to be "30 pinner road"
#  Then I should see "You don't have permission"
#  And I should be on the charity page for "Friendly"
#  Given I visit the home page
#  Then the coordinates for "Nice" and "Friendly" should not be the same

Scenario: Do not see edit button as non-admin not associated with Friendly
  Given I am signed in as a charity worker unrelated to "Friendly"
  And I visit the show page for the organisation named "Friendly"
  Then I should not see an edit button for "Friendly" charity

Scenario: Non-logged in users do not see edit button either
  Given I visit the show page for the organisation named "Friendly"
  Then I should not see an edit button for "Friendly" charity

Scenario: Change the address of a charity when Google is indisposed
  Given I am signed in as a charity worker related to "Friendly"
  And I update "Friendly" charity address to be "83 pinner road" when Google is indisposed
  Then I should not see the unable to save organisation error
  Then the address for "Friendly" should be "83 pinner road"
  # TODO Then I should see "Failed to update map coordinates"
  And I visit the show page for the organisation named "Friendly"
#  TODO possible follow on if we could have the request re-issued on next page load
#  Given Google is no longer indisposed
#  And I visit the home page
#  Then the coordinates for "Friendly" should be correct
#  Then show me the page

Scenario: Redirected to sign-in when not signed-in and edit donation url
  Given I visit the edit page for the organisation named "Friendly"
  Then I should be on the sign in page
# TODO after sign in is take the user back to the edit page

Scenario: By default, not display organisations address and phone number on home page
  Given I visit the show page for the organisation named "Friendly"
  Then I should not see any address or telephone information for "Nice" and "Friendly"

Scenario: By default, not display organisations edit and delete on home page
  Given I visit the show page for the organisation named "Friendly"
  Then I should not see any edit or delete links

Scenario: By default, not display organisations address and phone number on details page
  Given I visit the show page for the organisation named "Friendly"
  Then I should not see any address or telephone information for "Friendly"

Scenario: By default, not display edit link on details page
  Given I visit the show page for the organisation named "Friendly"
  Then I should not see any edit link for "Friendly"
  
Scenario Outline: Edit page has scroll box for selecting categories
  Given I am signed in as a charity worker related to "Friendly"
  And I visit the edit page for the organisation named "Friendly"
  Then I should see the category named <category_name> as the <nth> category in <heading>
Examples:
  | heading      | category_name       | nth |
  | What you do  | Animal welfare      | 1st |
  | What you do  | Child welfare       | 2nd |
  | What you do  | Feed the hungry     | 3rd |
  | Who you help | Accommodation       | 1st |
  | Who you help | General             | 2nd |
  | Who you help | Health              | 3rd |
  | How you help | Education           | 1st |
  | How you help | Give them things    | 2nd |
  | How you help | Teach them things   | 3rd |
  
Scenario Outline: Appropriate categories are checked/unchecked by default
  Given I am signed in as a charity worker related to "Friendly"
  And I visit the edit page for the organisation named "Friendly"
  Then the category named <category> should be <status>
Examples:
  | category          | status       |
  | Health            | checked      |
  | Education         | checked      |
  | Animal welfare    | unchecked    |
  | Child welfare     | unchecked    |
  | Feed the hungry   | unchecked    |
  | Accommodation     | unchecked    |
  | General           | unchecked    |
  | Teach them things | unchecked    |
  | Give them things  | unchecked    |

Scenario Outline: Successfully add and remove an organisation's categories
  Given I am signed in as a charity worker related to "Friendly"
  And I visit the edit page for the organisation named "Friendly"
  Then I <action1> the category "<category1>"
  And I <action2> the category "<category2>"
  And I press "Update Organisation"
  Then I should <visibility1> "<category1>"
  And I should <visibility2> "<category2>"
  Examples: 
  | category1      | action1    | visibility1 | category2            | action2 | visibility2 |
  | Health         | uncheck    | not see     | Child welfare        | check   | see         |
  | Animal welfare | check      | see         | Education            | uncheck | not see     |
  | Health         | uncheck    | not see     | Education            | uncheck | not see     |
  | General        | check      | see         | Give them things     | check   | see         |
