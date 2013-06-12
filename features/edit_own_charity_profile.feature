Feature: Charity worker can edit own charity profile
  As a charity worker
  So that I can increase my charity's visibility
  I want to edit my charity's web page (description and contact details)
  Tracker story ID: https://www.pivotaltracker.com/story/show/45671099

#address of friendly clone must be 30 pinner road because of change the address of charity scenario
#need to revisit this
Background: organizations have been added to database 
  Given the following organizations exist:
  | name           | description               | address        | postcode | telephone |
  | Friendly       | Bereavement Counselling   | 34 pinner road | HA1 4HZ  | 020800000 |
  | Friendly Clone | Quite Friendly!           | 30 pinner road | HA1 4HZ  | 020800010 |
  
  Given the following users are registered:
  | email             | password | organization|
  | jcodefx2@gmail.com | pppppppp | Friendly    |
  | jcodefx@gmail.com | pppppppp |        |

Scenario: Successfully change the address of a charity
  Given I am on the sign in page
  And I sign in as "jcodefx2@gmail.com" with password "pppppppp"
  Given I update "Friendly" charity address to be "30 pinner road"
  Then I am on the home page
  And the coordinates for "Friendly Clone" and "Friendly" should be the same

Scenario: Unsuccessfully change the address of a charity
  Given I am signed in as a charity worker unrelated to "Friendly"
  Given I furtively update "Friendly" charity address to be "30 pinner road"
  Then show me the page
  And I should see "You don't have permission"
  Then I am on the home page
  And the coordinates for "Friendly Clone" and "Friendly" should not be the same

Scenario: Do not see edit button as non-admin not associated with Friendly
  Given I am on the sign in page
  And I sign in as "jcodefx@gmail.com" with password "pppppppp"
  And I am on the charity page for "Friendly"
  Then I should not see an edit button for "Friendly" charity

Scenario: Non-logged in users do not see edit button either
  Given I am on the charity page for "Friendly"
  Then I should not see an edit button for "Friendly" charity

Scenario: Change the address of a charity when Google is indisposed
  Given I am on the sign in page
  And I sign in as "jcodefx2@gmail.com" with password "pppppppp"
  Given I am on the edit charity page for "Friendly"
  And I edit the charity address to be "83 pinner road" when Google is indisposed
  And I press "Update Organization"
  Then I should not see the unable to save organization error
  Then the address for "Friendly" should be "83 pinner road"
  And I am on the home page
#  Given Google is no longer indisposed
#  And I am on the home page
#  Then the coordinates for "Friendly" should be correct
#  Then show me the page

Scenario: Redirected to sign-in when not signed-in and edit donation url
  Given I am furtively on the edit charity page for "Friendly"
  Then I should be on the sign in page

Scenario: By default, not display organizations address and phone number on home page
  Given I am on the home page
  Then I should not see any address or telephone information for "Friendly Clone" and "Friendly"

Scenario: By default, not display organizations edit and delete on home page
  Given I am on the home page
  Then I should not see any edit or delete links

Scenario: By default, not display organizations address and phone number on details page
  Given I am on the charity page for "Friendly"
  Then I should not see any address or telephone information for "Friendly"

Scenario: By default, not display edit link on details page
  Given I am on the charity page for "Friendly"
  Then I should not see any edit link for "Friendly"
