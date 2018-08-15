# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    balance 1000

    trait :today do
      the_date Date.today
    end

    trait :yesterday do
      the_date Date.today - 1
    end

    trait :two_days_ago do
      the_date Date.today - 2
    end

    trait :restaurant do
      shop 'restaurant'
    end

    trait :market do
      shop 'market'
    end

    trait :cash do
      the_type 'cash'
    end

    trait :pos do
      the_type 'pos'
    end

    trait :payer_sean do
      payer 'Sean'
    end

    trait :payer_fiona do
      payer 'Fiona'
    end

    trait :amount_small do
      amount(-10)
    end

    trait :amount_big do
      amount(-200)
    end

    trait :with_purpose do
      association :purpose_id, factory: :purpose_food_buying
    end

    factory :transaction_1, traits: %i[two_days_ago restaurant cash payer_sean amount_small]
    factory :transaction_2, traits: %i[two_days_ago market pos payer_sean amount_small]
    factory :transaction_3, traits: %i[two_days_ago restaurant cash payer_fiona amount_big]
    factory :transaction_4, traits: %i[yesterday market cash payer_fiona amount_big]
    factory :transaction_5, traits: %i[yesterday restaurant pos payer_sean amount_small]
    factory :transaction_6, traits: %i[today restaurant cash payer_sean amount_small]
    factory :transaction_7, traits: %i[today restaurant cash payer_fiona amount_small]
    factory :transaction_8, traits: %i[today market pos payer_sean amount_big]
  end
end
