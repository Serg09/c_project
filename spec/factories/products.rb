FactoryGirl.define do
  factory :product do
    book
    caption { Faker::Commerce.department}
    sku { Faker::Code.isbn }
  end
end
