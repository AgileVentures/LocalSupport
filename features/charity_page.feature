Feature: Web page owned by each charity
  As a charity worker
  So that I can increase my charity's visibility
  I want to have a web presence
  Tracker story ID: https://www.pivotaltracker.com/story/show/45405153

  Background: organizations have been added to database
    Given the following organizations exist:
      | name           | description               | address        | postcode | telephone | website |
      | Friendly       | Bereavement Counselling   | 34 pinner road | HA1 4HZ  | 020800000 | http://friendly.org  |
      | Friendly Clone | Quite Friendly!           | 30 pinner road | HA1 4HZ  | 020800010 |         |

    Given the following users are registered:
      | email             | password | organization | confirmed_at |
      | jcodefx2@gmail.com | pppppppp | Friendly    | 2007-01-01  10:00:00 |
      | jcodefx@gmail.com | pppppppp |              | 2007-01-01  10:00:00 |

  Scenario: be able to view charity webpage
    Given I am on the charity page for "Friendly"
    Then I should see a link with text "http://friendly.org"

  Scenario:  be able to view charity webpage when no charity website link is available
    Given I am on the charity page for "Friendly Clone"
    Then I should see "We don't yet have a website link for them."
