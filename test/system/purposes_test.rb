# frozen_string_literal: true

require 'application_system_test_case'

class PurposesTest < ApplicationSystemTestCase
  setup do
    @purpose = purposes(:one)
  end

  test 'visiting the index' do
    visit purposes_url
    assert_selector 'h1', text: 'Purposes'
  end

  test 'creating a Purpose' do
    visit purposes_url
    click_on 'New Purpose'

    click_on 'Create Purpose'

    assert_text 'Purpose was successfully created'
    click_on 'Back'
  end

  test 'updating a Purpose' do
    visit purposes_url
    click_on 'Edit', match: :first

    click_on 'Update Purpose'

    assert_text 'Purpose was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Purpose' do
    visit purposes_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Purpose was successfully destroyed'
  end
end
