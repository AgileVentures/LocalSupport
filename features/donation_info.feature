Feature: Local Resident looking to donate
  As a local resident
  So that I can help local charities
  I want to find out how I can donate
  Tracker story ID: https://www.pivotaltracker.com/story/show/45392735

Background: organizations have been added to database
  
  Given the following organizations exist:
    | name                            | donation_info | address |
    | Harrow Bereavement Counselling  | www.harrow-bereavment.co.uk/donate | 34 pinner road |
    | Indian Elders Associaton        | www.indian-elders.co.uk/donate | 64 pinner road |
    | Age UK                          | www.age-uk.co.uk/donate | 84 pinner road |
  #adding this to the above table makes the donation_info not be nil.  need to find better solution
  Given the following organizations exist:
    |name             | address        |
    |Friendly Charity | 83 pinner road |

Scenario: Org page of an organization with donation info URL
  Given I am on the charity page for "Age UK"
  Then I should see the donation_info URL for "Age UK"
 
Scenario: Org page of an organization without donation info URL 
  Given I am on the charity page for "Friendly Charity"
  Then I should not see the donation_info URL for "Friendly Charity"
  
  


