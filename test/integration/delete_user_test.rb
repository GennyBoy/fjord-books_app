# frozen_string_literal: true

require 'test_helper'

class DeleteUserTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
  end

  test 'can delete a user account' do
    sign_in(@user)

    get edit_user_registration_path
    assert_select 'h2', 'アカウントを編集'

    assert_difference('User.count', -1) do
      delete user_registration_path
    end
  end
end
