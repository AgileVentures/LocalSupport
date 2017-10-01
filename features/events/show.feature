Feature: View one event
    As a user of the community 
    I would like to get details about an event i am interested in 
    Therefore I should see the details on a certain page

    Background: The following event has been added to the database

        Given the following event exists:
            | title          | description       | 
            | Open Source Weekend | Good for everyone |

    Scenario:
        Given I visit "Open Source Weekend" event




