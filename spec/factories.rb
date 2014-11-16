FactoryGirl.define do
  factory :organisation do
    before(:create) do |org|
      org.stub(:geocode)
    end
    name "friendly non profit"
    description "we are really really friendly"
    address "64 pinner road"
    postcode "HA1 3TE"
    donation_info 'www.harrow-bereavment.co.uk/donate'
    email "friendly@charity.org"
    latitude 10
    longitude 10
  end
  factory :category do
    name "health"
    charity_commission_id 1
    charity_commission_name "weird!"
  end
  factory :page do
    name 'About Us'
    permalink 'about'
    content 'abc123'
    link_visible true
  end
  factory :user do
    email "jj@example.com"
    password "pppppppp"
    confirmed_at "2007-01-01 10:00:00"
    admin false
    organisation nil

    factory :user_stubbed_organisation do
      after(:build) do |user|
        org = FactoryGirl.build(:organisation)
        org.save!
        user.organisation = org
        user.save!
      end
    end
  end

  factory :volunteer_op do
    title "Help out"
    description "Some nice people"
  end
end
