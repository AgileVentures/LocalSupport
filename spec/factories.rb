FactoryGirl.define do

  factory :organisation do
    name "friendly non profit"
    description "we are really really friendly"
    address "64 pinner road"
    postcode "HA1 3TE"
    donation_info 'www.harrow-bereavment.co.uk/donate'
    email "friendly@charity.org"
    latitude 10
    longitude 10
    factory :organisation_with_owner do
      after(:build) do |org|
        owner = FactoryGirl.build(:user)
        org.users << owner
        org.save!
      end
    end
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
