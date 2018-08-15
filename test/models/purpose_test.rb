# frozen_string_literal: true

require 'test_helper'

class PurposeTest < ActiveSupport::TestCase
  setup do
    @buy_food = create :purpose_food_buying, :with_transac
  end

  test 'create purpose' do
    @shopping = build :purpose_shopping
    assert @shopping.save

    @repeat_purpose = build :purpose_food_buying
    assert_not @repeat_purpose.valid?
  end

  test 'delete purpose' do
    @shopping = create :purpose_shopping
    assert @shopping.destroy
    assert_equal 1, @buy_food.transactions.count
    assert_not @buy_food.destroy
  end
end
