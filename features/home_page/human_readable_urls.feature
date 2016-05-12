@vcr
Feature:  Human friendly URLs
  As a human being
  So that I can make sense of organisation urls in emails etc.
  I would like the site URLs to have human friendly names

  # acceptance (slow running, low coverage)

  Background:
    Given the following organisations exist:
      | name                                                                          | description | address        | postcode | website       |
      | The Most Noble Great Charity of London                                        | ...         | 34 pinner road | HA1 4HZ  | http://a.com/ |
      | The Parochial Church Council Of The Ecclesiastical Parish Of St. Alban, North | ...         | 34 pinner road | HA1 4HZ  | http://a.com/ |

  Scenario: Human friendly name
    Given that I am on the home page
    Then I should see the link "/organisations/most-noble-great"