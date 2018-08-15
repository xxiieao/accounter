# frozen_string_literal: true

require 'test_helper'

class DataServiceControllerTest < ActionDispatch::IntegrationTest
  setup do
    @buy_food = create :purpose_food_buying
    @shopping = create :purpose_shopping
    1.upto(8) do |iter|
      trans = create "transaction_#{iter}"
      trans.purpose_id = @buy_food.id
      trans.purpose_id = @shopping.id if iter >= 5
      trans.save
    end
    @params = { data_service: { start_date: (Date.today - 5).to_s, end_date: Date.today.to_s } }
  end

  test 'should get root' do
    get root_url
    assert_response :success
  end

  test 'should get index' do
    get data_service_index_url
    assert_response :success
  end

  test 'should get daily aggregate data' do
    post daily_aggregate_data_service_index_url, params: @params
    assert_response :success
    expect_result = {
      'series' => [
        {
          'name' => 'spent',
          'data' => [0.0, 0.0, 0.0, 220.0, 210.0, 220.0],
          'pointStart' => (Date.today - 5).to_s,
          'pointInterval' => 86_400_000
        },
        {
          'name' => 'income',
          'data' => [0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
          'pointStart' => (Date.today - 5).to_s,
          'pointInterval' => 86_400_000
        },
        {
          'name' => 'balance',
          'data' => [0.0, 0.0, 0.0, 1000.0, 1000.0, 1000.0],
          'pointStart' => (Date.today - 5).to_s,
          'pointInterval' => 86_400_000
        }
      ]
    }
    assert_equal expect_result, JSON.parse(response.body)
  end

  test 'should get consumption aggregate data' do
    post consumption_aggregate_data_service_index_url, params: @params
    assert_response :success
    expect_result = {
      'series' => [{
        'data' => [
          { 'name' => 'food cost', 'y' => 420.0 },
          { 'name' => 'shopping cost', 'y' => 230.0 }
        ]
      }]
    }
    assert_equal expect_result, JSON.parse(response.body)
  end
end
