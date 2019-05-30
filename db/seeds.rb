# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Logger.new(STDOUT).info 'Start Organisations seed'
100.times do
  Organisation.create(
    name: Faker::Company.name,
    address: Faker::Address.street_address,
    postcode: Faker::Address.zip_code,
    email: Faker::Internet.email,
    description: Faker::DrWho.quote,
    website: Faker::Internet.url,
    telephone: Faker::PhoneNumber.phone_number,
    latitude: rand(51.546702..51.6247775).round(7),
    longitude: rand(-0.4476553..-0.2687842).round(7),
    gmaps: Faker::Boolean.boolean,
    donation_info: Faker::Lorem.paragraph,
    publish_address: Faker::Boolean.boolean,
    publish_phone: Faker::Boolean.boolean,
    publish_email: Faker::Boolean.boolean,
    type: 'Organisation',
    non_profit: Faker::Boolean.boolean
  )
end

organisations = Organisation.all

Logger.new(STDOUT).info 'Events seed'
organisations.each do |organisation|
  event_day = Date.today + rand(30)
  organisation.events.create(
    title: Faker::Book.title,
    description: Faker::Robin.quote,
    start_date: event_day,
    end_date: event_day + rand(1..5).hours,
    latitude: organisation.latitude,
    longitude: organisation.longitude
  )
end

Logger.new(STDOUT).info 'Services Seed'
5.times do
  Service.create(
    contact_id: Faker::Internet.email,
    name: Faker::Company.name,
    description: Faker::Lorem.sentences,
    email: Faker::Internet.email,
    telephone: Faker::PhoneNumber.phone_number,
    website: Faker::Internet.url,
    latitude: rand(51.546702..51.6247775).round(7),
    longitude: rand(-0.4476553..-0.2687842).round(7),
    address: Faker::Address.street_address,
  )
end

Logger.new(STDOUT).info 'Start Users seed'
User.create(
  email: 'superadmin@harrowcn.org.uk',
  password: 'asdf1234',
  password_confirmation: 'asdf1234',
  confirmed_at: DateTime.now,
  superadmin: true
)

User.create(
    email: 'siteadmin@harrowcn.org.uk',
    password: 'asdf1234',
    password_confirmation: 'asdf1234',
    confirmed_at: DateTime.now,
    superadmin: true
)

120.times do |i|
  user = User.where(email: "user#{i}@example.com").first_or_initialize
  user.password = "asdf1234"
  user.password_confirmation = "asdf1234"
  user.confirmed_at = DateTime.now
  user.organisation_id = Organisation.all.sample.id
  user.save!
end

user_ids = User.pluck(:id)
Logger.new(STDOUT).info 'Proposed Organisation Edits seed'
organisations.each do |organisation|
  organisation.edits.create(
    name: Faker::Company.name,
    address: Faker::Address.full_address,
    postcode: Faker::Address.postcode,
    email: Faker::Internet.email,
    description: Faker::Superhero.descriptor,
    website: Faker::Internet.url,
    telephone: Faker::PhoneNumber.phone_number,
    donation_info: Faker::Superhero.power,
    user_id: user_ids.shuffle.first,
    accepted: Faker::Boolean.boolean,
    archived: Faker::Boolean.boolean
  )
end

Logger.new(STDOUT).info 'Start VolunteerOps seed'
3.times do |n|
  VolunteerOp.create(description: "This is a test#{n}", title: "Test#{n}", organisation_id: "#{1 + n}")
end

Logger.new(STDOUT).info 'Start features seed'
Feature.create(name: 'volunteer_ops_create')
Feature.activate('volunteer_ops_create')
Feature.create(name: 'volunteer_ops_list')
Feature.activate('volunteer_ops_list')
Feature.create(name: 'automated_propose_org')
Feature.activate('automated_propose_org')
Feature.create(name: 'search_input_bar_on_org_pages')
Feature.activate('search_input_bar_on_org_pages')
Feature.create(name: 'doit_volunteer_opportunities')
Feature.activate('doit_volunteer_opportunities')
Feature.create(name: 'reachskills_volunteer_opportunities')
Feature.activate('reachskills_volunteer_opportunities')
Feature.create(name: 'events')
Feature.activate('events')
Feature.create(name: 'services')

Logger.new(STDOUT).info 'Seed completed'
