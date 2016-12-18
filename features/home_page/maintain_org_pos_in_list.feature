Feature: maintain position in organisation list
  As any user
  In order to ease navigation via organisation list
  I would like to open each organisation page in new tab/window
  
  Background: organisations have been added to database
    
    Given the following organisations exist:
      | name                           | description                    | address        | postcode | website       |
      | Harrow Bereavement Counselling | Harrow Bereavement Counselling | 34 Pinner Road | HA1 4HZ  | http://a.com/ |

  Scenario:
    When I visit the home page
    Then I should see link "Harrow Bereavement Counselling" targeting new page