FactoryGirl.define do
  factory :organization do
    name "friendly non profit"
    description "we are really really friendly"
    address "64 pinner road"
    postcode "HA1 3TE"
    donation_info 'www.harrow-bereavment.co.uk/donate'
  end
  factory :category do
    name "health"
    charity_commission_id 1
    charity_commission_name "weird!"
  end
  factory :admin_user , class: User do
    email "admin@example.com"
    password "pppppppp"
    confirmed_at "2007-01-01 10:00:00"
    admin true
    organization nil
    charity_admin_pending false
  end

  factory :user do
    email "jj@example.com"
    password "pppppppp"
    confirmed_at "2007-01-01 10:00:00"
    admin false
    organization nil
    charity_admin_pending false

    factory :user_stubbed_organization do
      after(:build) do |user|
        Gmaps4rails.stub(:geocode)
        org = FactoryGirl.build(:organization)
        org.save!
        user.organization = org
        user.save!
      end
    end
  end
end
