# frozen_string_literal: true

require 'test_helper'

class CreateUserTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
  end

  test 'can create a user account' do
    get new_user_registration_path
    assert_select 'h2', 'アカウント登録'

    assert_difference('User.count', 1) do
      post user_registration_path,
           params: {
             user: {
               email: 'test3@example.com',
               password: 'password',
               password_confirmation: 'password',
               post_code: '222-2222',
               address: '千葉県千葉市1-1-1',
               self_introduction: 'This is my self intro'
             }
           }
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'p', 'アカウント登録が完了しました。'
  end

  test 'cannot create a user account when password_confirmation is not same as password' do
    assert_no_difference('User.count') do
      post user_registration_path,
           params: {
             user: {
               email: 'test3@example.com',
               password: 'password',
               password_confirmation: 'wrong_password',
               post_code: '222-2222',
               address: '千葉県千葉市1-1-1',
               self_introduction: 'This is my self intro'
             }
           }
    end
    assert_response :success
    assert_select '#error_explanation h2', 'エラーが発生したため ユーザー は保存されませんでした:'
    assert_select 'li', 'パスワード（確認用）とパスワードの入力が一致しません'
  end

  test 'cannot create a user account when email is blank' do
    assert_no_difference('User.count') do
      post user_registration_path,
           params: {
             user: {
               email: '',
               password: 'password',
               password_confirmation: 'password',
               post_code: '222-2222',
               address: '千葉県千葉市1-1-1',
               self_introduction: 'This is my self intro'
             }
           }
    end
    assert_response :success
    assert_select 'h2', 'エラーが発生したため ユーザー は保存されませんでした:'
    assert_select 'li', 'Eメールを入力してください'
  end
end
