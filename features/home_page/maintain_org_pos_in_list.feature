Feature: maintain position in organisation list
  As any user
  In order to ease navigation via organisation list
  I would like to open each organisation page in new tab/window
  When clicking on an organisation link
  
  Background: organisations have been added to database
    
    Given the following organisations exist:
      | name                           | description                    | address        | postcode | website       |
      | Harrow Bereavement Counselling | Harrow Bereavement Counselling | 34 Pinner Road | HA1 4HZ  | http://a.com/ |
      | Indian Elders Association      | Care for the elderly           | 64 Pinner Road | HA1 4HZ  | http://b.com/ |
      | Age UK                         | Care for the Elderly           | 84 Pinner Road | HA1 4HZ  | http://c.com/ |
      | Youth UK                       | Care for the Very Young        | 84 Pinner Road | HA1 4HZ  | http://d.com/ |
      | Wrong Postcode UK              | Confused                       | 50 City Road   | HA1 4HZ  | http://e.com/ |

    And I visit the home page
  
  @multiple_windows  
  Scenario: Click on an organisation down the list
    When I click "Wrong Postcode UK" in original window
    Then a new window must appear
    And I should be on the home page in original window