# frozen_string_literal: true

require 'test_helper'

class TransactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @transaction_with_purpose = create :transaction_1, :with_purpose
    @transaction_without_purpose = create :transaction_2
    @shopping = create :purpose_shopping
  end

  test 'should get index' do
    get transactions_url
    assert_response :success
  end

  test 'should get edit' do
    get edit_transaction_url(@transaction_with_purpose)
    assert_response :success

    get edit_transaction_url(@transaction_without_purpose)
    assert_response :success
  end

  test 'should update transaction' do
    params = { transaction: { purpose_id: @shopping.id } }
    patch transaction_url(@transaction_with_purpose), params: params
    assert_redirected_to transactions_url
    @shopping.reload
    assert_equal 1, @shopping.counter

    patch transaction_url(@transaction_without_purpose), params: params
    assert_redirected_to transactions_url
    @shopping.reload
    assert_equal 2, @shopping.counter
  end

  test 'should get unassorted transaction' do
    get unassorted_transactions_url
    assert_response :success
  end

  test 'should batch update transactions purpose_id' do
    params = {
      transaction: {
        ids: [@transaction_without_purpose.id, @transaction_with_purpose.id],
        purpose_ids: [@shopping.id, @shopping.id]
      }
    }
    post purpose_confirm_transactions_url, params: params
    assert_redirected_to unassorted_transactions_url

    @shopping.reload
    assert_equal @shopping.counter, 2
  end

  test 'should import data' do
    params = {
      transaction: {
        data: [
          %w[the_type shop payer the_date   amount balance],
          %w[POS      KFC  Mike  2018-08-01     20   10000],
          %w[]
        ]
      }
    }
    assert_difference 'Transaction.count', 1 do
      post batch_create_transactions_url, params: params, as: :json
    end
    assert_response 200

    params = {
      transaction: {
        data: [
          %w[the_type shop payer the_date   amount balance],
          %w[POS      KFC  Mike  2018-08-01]
        ]
      }
    }
    post batch_create_transactions_url, params: params, as: :json
    assert_response 400

    params = { transaction: { data: "some random text" }}
    post batch_create_transactions_url, params: params, as: :json
    assert_response 400

    params = { transaction: { data: [""] }}
    post batch_create_transactions_url, params: params, as: :json
    assert_response 400

    params = { transaction: { data: [[""]] }}
    post batch_create_transactions_url, params: params, as: :json
    assert_response 400
  end
end
