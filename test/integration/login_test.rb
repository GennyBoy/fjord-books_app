# frozen_string_literal: true

require 'test_helper'

class LoginTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
  end

  test 'can login' do
    get new_user_session_path
    assert_select 'h2', 'ログイン'

    post user_session_path,
         params: {
           user: {
             email: 'test1@example.com',
             password: 'password'
           }
         }

    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'p', 'ログインしました。'
  end

  test 'cannot login with wrong password' do
    get new_user_session_path
    assert_select 'h2', 'ログイン'

    post user_session_path,
         params: {
           user: {
             email: 'test1@example.com',
             password: 'wrong_password'
           }
         }

    assert_response :success
    assert_select 'p', 'Eメール もしくはパスワードが不正です。'
  end

  test 'redirect to the login page when not logged in' do
    get books_path
    assert_redirected_to new_user_session_path

    get users_path
    assert_redirected_to new_user_session_path
  end
end
