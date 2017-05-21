Feature: List the upcoming events
    As a member of the public
    So that I can find out what's going on in my area
    I would like to see a list of the upcoming evens

    Background: Events have been added to the database

        Given the following events exist:
            | title          | description       | start_date      | end_date |
            | My first event | Good for everyone | 2 days from now | same day |

    Scenario:
        Given I visit the events page
        Then I should see "My first event"


