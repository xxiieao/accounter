# frozen_string_literal: true

FactoryBot.define do
  factory :purpose_food_buying, class: Purpose do
    the_name 'food cost'

    trait :with_transac do
      after(:create) do |purpose|
        create_list :transaction_1, 1, purpose: purpose
      end
    end
  end

  factory :purpose_shopping, class: Purpose do
    the_name 'shopping cost'
  end
end
