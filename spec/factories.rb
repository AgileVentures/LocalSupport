FactoryBot.define do
  factory :organisation do
    name { 'friendly non profit' }
    description { 'we are really really friendly' }
    address { '64 pinner road' }
    postcode { 'HA1 4HZ' }
    donation_info { 'www.harrow-bereavment.co.uk/donate' }
    email { 'friendly@charity.org' }
    latitude { 10 }
    longitude { 10 }
    factory :organisation_with_owner do
      after(:build) do |org|
        owner = FactoryBot.build(:user)
        org.users << owner
        org.save!
      end
    end
  end

  factory :friendly_id_org, class: Organisation do
    name { 'The Most Noble Great Charity of London' }
    description { 'Really big, rich and generous charity' }
    after(:build, &:save!)
  end

  factory :parochial_org, class: Organisation do
    name { 'The Parochial Church Council Of The Ecclesiastical Parish Of St. Alban, North' }
    description { 'Church charity' }
    after(:build, &:save!)
  end

  factory :proposed_organisation_edit do

  end

  factory :proposed_organisation do
    name { 'Friendly Charity' }
    description { 'We are friendly!' }
    address { '64 pinner road' }
    postcode { 'HA1 4HZ' }
    donation_info { 'www.donate.org/friendly' }
    email { 'friendly@charity.org' }
    latitude { 10 }
    longitude { 10 }
    non_profit { true }
    after(:build) do |proposed_org|
      owner = FactoryBot.create(:user)
      proposed_org.users << owner
      proposed_org.save!
    end
  end

  factory :orphan_proposed_organisation, class: ProposedOrganisation do
    name { 'Friendly Charity' }
    description { 'We are friendly!' }
    address { '64 pinner road' }
    postcode { 'HA1 4HZ' }
    donation_info { 'www.donate.org/friendly' }
    email { 'friendly@charity.org' }
    latitude { 10 }
    longitude { 10 }
    non_profit { true }
  end

  factory :category do
    name { 'health' }
    charity_commission_id { 1 }
    charity_commission_name { 'weird!' }
  end

  factory :page do
    name { 'About Us' }
    permalink { 'about' }
    content { 'abc123' }
    link_visible { true }
  end

  factory :user do
    sequence(:email) { |n| "jj#{n}@example.com" }
    password { 'pppppppp' }
    confirmed_at { '2007-01-01 10:00:00' }
    superadmin { false }
    organisation { nil }

    factory :user_stubbed_organisation do
      after(:build) do |user|
        org = FactoryBot.build(:organisation)
        org.save!
        user.organisation = org
        user.save!
      end
    end
    factory :deleted_user do
      deleted_at { 1.year.ago }
    end
  end

  factory :volunteer_op do
    title { 'Help out' }
    description { 'Some nice people' }

    factory :local_volunteer_op do
    end

    factory :doit_volunteer_op do
      source { 'doit' }
    end

    factory :reachskills_volunteer_op do
      source { 'reachskills' }
    end
  end

  factory :invitation_instructions, class: MailTemplate do
    name { 'Invitation instructions' }
    body { 'Test template body' }
    footnote { 'Test template footnote' }
    email { 'test@test.com' }
  end

  factory :event do
    title { 'Some Random Event' }
    description { 'Something about an event' }
    start_date { DateTime.current }
    end_date { DateTime.current + 2.hours }
    address { '34 pinner road' }
    association :organisation, factory: :organisation
  end

  factory :upcoming_events, class: Event do
    title { 'Upcoming Event' }
    description { 'An event that is coming up soon' }
    start_date { DateTime.current + 1.day }
    end_date { DateTime.current + 2.days }
    association :organisation, factory: :organisation
  end

  factory :previous_events, class: Event do
    title { 'Past Event' }
    description { 'An event that has already passed' }
    start_date { DateTime.current - 2.days }
    end_date { DateTime.current - 1.day }
    association :organisation, factory: :organisation
  end

  factory :superadmin, class: User do
    sequence(:email) { |n| "jj#{n}@example.com" }
    password { 'pppppppp' }
    confirmed_at { '2007-01-01 10:00:00' }
    superadmin { true }
    organisation { nil }
  end
end
