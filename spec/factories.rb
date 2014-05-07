FactoryGirl.define do
  factory :organization do
    name 'friendly non profit'
    description 'we are really really friendly'
    address '64 pinner road'
    postcode 'HA1 3TE'
    donation_info 'www.harrow-bereavment.co.uk/donate'
  end

  factory :category do
    name 'health'
    charity_commission_id 1
    charity_commission_name 'weird!'
  end

  factory :page do
    name 'About Us'
    permalink 'about'
    content 'abc123'
    link_visible true
  end

  factory :user do
    email 'jj@example.com'
    password 'pppppppp'
    confirmed_at '2007-01-01 10:00:00'
    admin false
    organization nil

    factory :admin_user do
      admin true
    end

    factory :user_with_organization do
      organization
      # after(:build) do |user|
      #   user.organization = FactoryGirl.create(:organization)
      #   user.save!
      # end
    end
  end

  factory :volunteer_op do
    title 'Help out'
    description 'Some nice people'
  end
end
