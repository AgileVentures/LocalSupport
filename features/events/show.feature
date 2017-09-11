Feature: View one event
    As a member of the public
    If I click on event title
    I will see details regarding the individual event

    Background: The following event has been added to the database

        Given the following event exist:
            | title          | description       | start_date      | end_date |
            | My first event | Good for everyone | 2 days from now | same day |

    Scenario:
        Given I visit the events/1 page
        Then I should see "My first event"




