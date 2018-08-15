# frozen_string_literal: true

require 'test_helper'

class TransactionTest < ActiveSupport::TestCase
  setup do
    @transaction = create :transaction_1
    @buy_food = create :purpose_food_buying
    @shopping = create :purpose_shopping
  end

  test 'trainsaction purpose confirm' do
    assert_not @transaction.confirmed?

    @transaction.purpose_id = @buy_food.id

    @transaction.save

    @transaction.reload
    @buy_food.reload

    assert_equal @buy_food, @transaction.purpose

    assert_equal 1, @buy_food.counter
    @buy_food.transaction_feature_counters.each do |feature|
      assert_equal 1, feature.counter
    end
  end

  test 'transaction change purpose after confirm' do
    assert_not @transaction.confirmed?

    @transaction.purpose_id = @buy_food.id

    @transaction.save
    @transaction.reload
    @buy_food.reload

    assert_equal 1, @buy_food.counter
    @buy_food.transaction_feature_counters.each do |feature|
      assert_equal 1, feature.counter
    end

    assert @transaction.confirmed?

    @transaction.purpose_id = @shopping.id
    assert @transaction.send :need_relearing?

    @transaction.save
    @transaction.reload
    @buy_food.reload
    @shopping.reload

    assert_equal 0, @buy_food.counter
    @buy_food.transaction_feature_counters.each do |feature|
      assert_equal 0, feature.counter
    end

    assert_equal 1, @shopping.counter
    @shopping.transaction_feature_counters.each do |feature|
      assert_equal 1, feature.counter
    end
  end

  test 'transaction purpose inference' do
    @transaction.purpose_id = @buy_food.id
    @transaction.save

    2.upto(6) do |iter|
      trans = create "transaction_#{iter}"
      trans.purpose_id = @buy_food.id
      trans.purpose_id = @shopping.id if iter >= 5
      trans.save
    end

    new_transaction1 = create :transaction_7
    new_transaction2 = create :transaction_8

    default_ratio = Transaction::NO_RECORD_WEIGHT

    assert_equal({ @buy_food.id => 0.375, @shopping.id => default_ratio },
                 new_transaction1.purpose_inference)
    assert_equal({ @buy_food.id => 0.125, @shopping.id => default_ratio**2 },
                 new_transaction2.purpose_inference)
  end

  test 'transaction batch create' do
    data = [%w[the_type shop payer the_date   amount balance],
            %w[POS      KFC  Mike  2018-08-01     20   10000]]
    assert_difference 'Transaction.count', 1 do
       Transaction.batch_create(data)
    end

    data = [%w[payer the_date   amount balance],
            %w[Mike  2018-08-01     20   10000]]
    assert_not Transaction.batch_create(data)
  end
end
