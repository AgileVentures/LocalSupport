namespace :db do
  task :pages => :environment do
    Page.create!({
                     name: 'About Us',
                     permalink: 'about',
                     content:
'# About Us
### Supporting groups in Harrow
We are a not-for-profit workers co-operative who support people and not-for-profit organisations to make a difference in their local community by:

1. Working with local people and groups to identify local needs and develop appropriate action.
2. Providing a range of services that help organisations to succeed.
3. Supporting and encouraging the growth of co-operative movement.

### How do we support?
Find out [here (VAH in a nutshell)](http://www.voluntaryactionharrow.org.uk/vah-in-a-nutshell)
### What is a Workers Co-operative?
A workers co-operative is a business owned and democratically controlled by their employee members using co-operative principles. They are an attractive and increasingly relevant alternative to traditional investor owned models of enterprise.[ (Click here for more details)](http://www.uk.coop/sites/default/files/worker_co-operative_code_2nd_edition.pdf)'
                 })

    Page.create!({
                     name: 'Contact Info',
                     permalink: 'contact',
                     content:
'# Contact Info
* **Email us:** [contact@voluntaryactionharrow.org.uk](mailto:contact@voluntaryactionharrow.org.uk)
* **Phone Us:** 020 8861 5894
* **Write to Us:** The Lodge, 64 Pinner Road, Harrow, Middlesex, HA1 4HZ
* **Find Us:** On [ Social Media (Click Here)](http://www.voluntaryactionharrow.org.uk/social-circles/)'
                 })

    Page.create!({
                     name: 'Disclaimer',
                     permalink: 'disclaimer',
                     content:
'# Disclaimer
#### Whilst Voluntary Action Harrow has made effort to ensure the information here is accurate and up to date we are reliant on the information provided by the different organisations. No guarantees for the accuracy of the information is made.'
                 })
  end
end