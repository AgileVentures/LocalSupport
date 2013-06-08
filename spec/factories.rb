FactoryGirl.define do
  factory :organization do
    name "friendly non profit"
    description "we are really really friendly"
  end
  factory :charity_worker do
    email "jj@example.com"
    password "pppppppp"
    admin false

    factory :charity_worker_stubbed_organization do
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
