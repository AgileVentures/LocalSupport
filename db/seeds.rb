# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Organization.import_addresses 'db/data.csv', 1006

user = User.new({
    email: "admin@harrowcn.org.uk",
    password: "asdf1234",
    password_confirmation: "asdf1234",
  })

user.confirmed_at = DateTime.now
user.admin = true

user.save!

Page.create!({
    name: 'About Us',
    permalink: 'about',
    content: '### Supporting groups in Harrow\r\n\r\nWe are a not-for-profit workers co-operative who support people and not-for-profit organisations to make a difference in their local community by:\r\n\r\n1.  Working with local people and groups to identify local needs and develop appropriate action.\r\n2.  Providing a range of services that help organisations to succeed.\r\n3.  Supporting and encouraging the growth of co-operative movement.\r\n\r\n\r\n### How do we support?\r\nFind out [here (VAH in a nutshell)](http://www.voluntaryactionharrow.org.uk/vah-in-a-nutshell)\r\n\r\n\r\n\r\n### What is a Workers Co-operative?\r\nA workers co-operative is a business owned and democratically controlled by their employee members using co-operative principles. They are an attractive and increasingly relevant alternative to traditional investor owned models of enterprise.[ (Click here for more details)](http://www.uk.coop/sites/default/files/worker_co-operative_code_2nd_edition.pdf)'
             })

Page.create!({
    name: 'Contact Info',
    permalink: 'contact',
    content: '*   **Email us:** [contact@voluntaryactionharrow.org.uk](mailto:contact@voluntaryactionharrow.org.uk)\r\n*   **Phone Us:** 020 8861 5894\r\n*   **Write to Us:** The Lodge, 64 Pinner Road, Harrow, Middlesex, HA1 4HZ\r\n*   **Find Us:** On [ Social Media (Click Here)](http://www.voluntaryactionharrow.org.uk/social-circles/)'
             })

Page.create!({
    name: 'Disclaimer',
    permalink: 'disclaimer',
    content: '#### Whilst Voluntary Action Harrow has made effort to ensure the information here is accurate and up to date we are reliant on the information provided by the different organisations. No guarantees for the accuracy of the information is made.'
             })