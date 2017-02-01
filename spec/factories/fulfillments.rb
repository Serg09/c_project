FactoryGirl.define do
  factory :fulfillment do
    contribution
    reward
    delivered false

    factory :electronic_fulfillment do
      type 'ElectronicFulfillment'
      email { Faker::Internet.email }
    end

    factory :physical_fulfillment do
      recipient { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
      type 'PhysicalFulfillment'
      address1  { Faker::Address.street_address }
      address2 { Faker::Address.secondary_address }
      city { Faker::Address.city }
      state { Faker::Address.state_abbr }
      postal_code { Faker::Address.postcode }
      country_code 'US'
    end
  end
end
