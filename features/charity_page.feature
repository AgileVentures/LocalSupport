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
      | registered_user-1@example.com | pppppppp | Friendly    | 2007-01-01  10:00:00 |
      | registered_user-2@example.com | pppppppp |              | 2007-01-01  10:00:00 |

  Scenario: be able to view link to charity site on individual charity page
    Given I am on the charity page for "Friendly"
    Then I should see the external website link for "Friendly" charity

  Scenario: get missing message when charity page has no charity website link available
    Given I am on the charity page for "Friendly Clone"
    Then I should see "We don't yet have a website link for them."

  Scenario: display charity title in a visible way
    Given I am on the charity page for "Friendly"
    Then I should see "Friendly" < tagged > with "h3"