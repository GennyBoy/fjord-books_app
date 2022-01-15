# frozen_string_literal: true

require 'application_system_test_case'

class LoginTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
  end

  test 'forgetting the password' do
    visit new_user_session_path

    click_on 'パスワードを忘れた方'

    fill_in 'Eメール', with: @user.email
    click_on 'パスワードの再設定方法を送信'

    assert_current_path user_session_path
    assert_text 'パスワードの再設定について数分以内にメールでご連絡いたします。'
  end

  test 'login with a user account' do
    visit new_user_session_path

    fill_in 'Eメール', with: @user.email
    fill_in 'パスワード', with: 'password'

    click_button 'ログイン'

    assert_current_path root_path
    assert_text 'ログインしました。'
    assert_text "ログインしているアカウント : #{@user.email}"
  end

  test 'unable to login with a wrong password' do
    visit new_user_session_path

    fill_in 'Eメール', with: @user.email
    fill_in 'パスワード', with: 'wrong_password'

    click_button 'ログイン'

    assert_current_path new_user_session_path
    assert_text 'Eメール もしくはパスワードが不正です。'
  end

  test 'unable to login with an unregistered email' do
    visit new_user_session_path

    fill_in 'Eメール', with: 'wrong_email@example.com'
    fill_in 'パスワード', with: 'password'

    click_button 'ログイン'

    assert_current_path new_user_session_path
    assert_text 'Eメール もしくはパスワードが不正です。'
  end
end
