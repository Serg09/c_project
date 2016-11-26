FactoryGirl.define do
  factory :product do
    book
    caption { Faker::Beer.style }
    sku { Faker::Code.isbn }
  end
end
