# frozen_string_literal: true

require 'test_helper'

class ForgettingPasswordTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
  end

  test 'can send an instruction of resetting password' do
    get new_user_password_path
    assert_select 'h2', 'パスワードを忘れた方'

    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      post user_password_path,
           params: {
             user: {
               email: 'test1@example.com'
             }
           }
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'p', 'パスワードの再設定について数分以内にメールでご連絡いたします。'
  end
end
