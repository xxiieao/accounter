# frozen_string_literal: true

require 'test_helper'

class PurposesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @purpose1 = create :purpose_food_buying, :with_transac
    @purpose2 = create :purpose_shopping
  end

  test 'should get index' do
    get purposes_url
    assert_response :success
  end

  test 'should get edit' do
    get edit_purpose_url(@purpose1)
    assert_response :success

    get edit_purpose_url(@purpose2)
    assert_response :success
  end

  test 'should create purpose' do
    assert_difference('Purpose.count', 1) do
      params = { purpose: { the_name: 'totally new name' } }
      post purposes_url params: params
      assert_redirected_to purposes_url
    end
  end

  test 'should update purpose' do
    params = { purpose: { the_name: 'another name' } }
    patch purpose_url(@purpose1), params: params
    assert_redirected_to purposes_url
  end

  test 'should delete purpose' do
    assert_difference('Purpose.count', 0) do
      delete purpose_url(@purpose1.id)
    end
    assert_redirected_to purposes_url

    assert_difference('Purpose.count', -1) do
      delete purpose_url(@purpose2.id)
    end
    assert_redirected_to purposes_url
  end
end
