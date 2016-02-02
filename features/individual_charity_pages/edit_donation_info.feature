Feature: Edit donation information feature
  As a charity worker
  So that I can attract funding
  I want to encourage local people to donate
  (charity worker can update a link to where they accept donations)

  Tracker story: https://www.pivotaltracker.com/s/projects/742821/stories/45405077

Background: organisations have been added to database
  Given the following organisations exist:
  | name           | description               | address        | postcode | telephone |
  | Friendly       | Bereavement Counselling   | 34 pinner road | HA1 4HZ  | 020800000 |

  Given the following users are registered:
  | email                       | password | superadmin | organisation | confirmed_at         |
  | registered_user@example.com | pppppppp | false      | Friendly     | 2007-01-01  10:00:00 |
  | registered_user2@example.com| pppppppp | false      |              | 2007-01-01  10:00:00 |
  And cookies are approved

@vcr
Scenario: Successfully change the donation url for a charity
  # TODO Refactor towards something like this
  #Given I am signed in as a charity superadmin for "Friendly"
  #And I update the "Friendly" donation url to be "http://www.friendly.com/donate"
  #And the donation_info URL for "Friendly" should refer to "http://www.friendly.com/donate"

  # TODO or ultimately even something like this
  # Charity Super Admins can edit their charity's donation info url

  #TODO: Refactor the sign in process to dry it out
  Given I visit the home page
  And I sign in as "registered_user@example.com" with password "pppppppp"
  Given I visit the edit page for the organisation named "Friendly"
  And I edit the donation url to be "http://www.friendly.com/donate"
  And I press "Update Organisation"
  Then I should be on the show page for the organisation named "Friendly"
  And I should see "Organisation was successfully updated"
  And the donation_info URL for "Friendly" should refer to "http://www.friendly.com/donate"

 #TODO: Refactor this into integration test that posts to the update method
#Scenario: Unsuccessfully change the donation url for a charity
  #Given I am signed in as a charity worker unrelated to "Friendly" with password "pppppppp"
 # Given I am on the sign in page
 # And I sign in as "registered_user2@example.com" with password "pppppppp"
 # Given I am furtively on the edit charity page for "Friendly"
 # And I edit the donation url to be "http://www.friendly.com/donate"
 # And I press "Update Organisation"
 # Then I should be on the charity page for "Friendly"
 # And I should see "You don't have permission"
 # And I should see "We don't yet have any donation link for them."
