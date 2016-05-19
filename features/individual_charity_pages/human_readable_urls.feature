@vcr
Feature:  Human friendly URLs
  As a human being
  So that I can make sense of organisation urls in emails etc.
  I would like the site URLs to have human friendly names

  Background:
    Given the following organisations exist:
      | name                                                                          | description | address        | postcode | website       |
      | The Most Noble Great 1 Charity of London                                      | a           | 34 pinner road | HA1 4HZ  | http://a.com/ |
      | The Most Noble Great 2 Charity of London                                      | b           | 35 pinner road | HA1 4HZ  | http://b.com/ | 
      | The Most Noble Great 3 Charity of London                                      | c           | 36 pinner road | HA1 4HZ  | http://c.com/ | 
      | The Most Noble Great 3 of Charity of London                                   | d           | 37 pinner road | HA1 4HZ  | http://d.com/ |
      | The Parochial Church Council Of The Ecclesiastical Parish Of St. Alban, North | e           | 38 pinner road | HA1 4HZ  | http://e.com/ |

    Given the following users are registered:
      | email                         | password | organisation                                                                       | confirmed_at         |
      | example1@example.com          | pppppppp | The Parochial Church Council Of The Ecclesiastical Parish Of St. Alban, North      | 2007-01-01  10:00:00 |
    
    Given the following volunteer opportunities exist:
      | title              | description                     | organisation                                                                  |
      | Our Heroes         | Save the world                  | The Most Noble Great 1 Charity of London                                      |
      | God Loves Us       | Help the atheists               | The Parochial Church Council Of The Ecclesiastical Parish Of St. Alban, North |

  Scenario: Human friendly links from home page
    Given I visit the home page
    Then the URL for "The Most Noble Great 1 Charity of London" should refer to "/organisations/most-noble-great"
    And the URL for "The Most Noble Great 2 Charity of London" should refer to "/organisations/most-noble-great-charity-london"
    And the URL for "The Most Noble Great 3 Charity of London" should refer to "/organisations/most-noble-great-3-charity-london-org"
    And the URL for "The Most Noble Great 3 of Charity of London" should refer to "/organisations/the-most-noble-great-3-of-charity-of-london"
    And the URL for "The Parochial Church Council Of The Ecclesiastical Parish Of St. Alban, North" should refer to "/organisations/parochial-church-st-alban-north"
    
  Scenario: Human friendly links from organisation show page
    Given I am signed in as a charity worker related to "The Parochial Church Council Of The Ecclesiastical Parish Of St. Alban, North" 
    Given that the volunteer_ops_create flag is enabled
    And I visit the show page for the organisation named "The Parochial Church Council Of The Ecclesiastical Parish Of St. Alban, North"
    Then the URL for "Edit" should refer to "/organisations/parochial-church-st-alban-north/edit"
    And the URL for "Create a Volunteer Opportunity" should refer to "/organisations/parochial-church-st-alban-north/volunteer_ops/new"
    
  Scenario: Human friendly links from volunteer_ops_path
    Given I visit the volunteer opportunities page
    Then the URL for "The Most Noble Great 1 Charity of London" should refer to "/organisations/most-noble-great"
    And the URL for "The Parochial Church Council Of The Ecclesiastical Parish Of St. Alban, North" should refer to "/organisations/parochial-church-st-alban-north"