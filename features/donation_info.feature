Feature: Local Resident looking to donate
  As a local resident
  So that I can help local charities
  I want to find out how I can donate
  Tracker story ID: 45392735

Background: organizations have been added to database
  
  Given the following organizations exist:
  | name                            | donation_info | address |
  | Harrow Bereavement Counselling  | www.harrow-bereavment.co.uk/donate | 34 pinner road |
  | Indian Elders Associaton        | www.indian-elders.co.uk/donate | 64 pinner road |
  | Age UK                          | www.age-uk.co.uk/donate | 84 pinner road |

Scenario: Show all charities on homepage map
  Given I am on the charity page for "Harrow Bereavement Counselling"
  
  


