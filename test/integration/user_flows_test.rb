# frozen_string_literal: true

require 'test_helper'

class UserFlowsTest < ActionDispatch::IntegrationTest
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

  test 'can edit a user account' do
    sign_in(@user)

    get edit_user_registration_path
    assert_select 'h2', 'アカウントを編集'

    patch user_registration_path,
          params: {
            user: {
              email: 'test1_edit@example.com',
              password: 'edit_password',
              password_confirmation: 'edit_password',
              post_code: '222-2222',
              address: '千葉県千葉市千葉１−１−１',
              self_introduction: 'これは新しい自己紹介文です',
              current_password: 'password'
            }
          }
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
    assert_select 'p', 'アカウント情報を変更しました。'

    @user.reload
    assert_equal 'test1_edit@example.com', @user.email
    assert_equal '222-2222', @user.post_code
    assert_equal '千葉県千葉市千葉１−１−１', @user.address
    assert_equal 'これは新しい自己紹介文です', @user.self_introduction
  end

  test 'cannot edit a user account with wrong current password' do
    sign_in(@user)

    get edit_user_registration_path
    assert_select 'h2', 'アカウントを編集'

    patch user_registration_path,
          params: {
            user: {
              email: 'test1_edit@example.com',
              password: 'edit_password',
              password_confirmation: 'edit_password',
              post_code: '222-2222',
              address: '千葉県千葉市千葉１−１−１',
              self_introduction: 'これは新しい自己紹介文です',
              current_password: 'wrong_password'
            }
          }
    assert_response :success
    assert_select 'h2', 'エラーが発生したため ユーザー は保存されませんでした:'
    assert_select 'li', '現在のパスワードは不正な値です'

    @user.reload
    assert_not_equal 'test1_edit@example.com', @user.email
    assert_not_equal '222-2222', @user.post_code
    assert_not_equal '千葉県千葉市千葉１−１−１', @user.address
    assert_not_equal 'これは新しい自己紹介文です', @user.self_introduction
  end

  test 'cannot edit a user account with blank current password' do
    sign_in(@user)

    get edit_user_registration_path
    assert_select 'h2', 'アカウントを編集'

    patch user_registration_path,
          params: {
            user: {
              email: 'test1_edit@example.com',
              password: 'edit_password',
              password_confirmation: 'edit_password',
              post_code: '222-2222',
              address: '千葉県千葉市千葉１−１−１',
              self_introduction: 'これは新しい自己紹介文です',
              current_password: ''
            }
          }
    assert_response :success
    assert_select 'h2', 'エラーが発生したため ユーザー は保存されませんでした:'
    assert_select 'li', '現在のパスワードを入力してください'

    @user.reload
    assert_not_equal 'test1_edit@example.com', @user.email
    assert_not_equal '222-2222', @user.post_code
    assert_not_equal '千葉県千葉市千葉１−１−１', @user.address
    assert_not_equal 'これは新しい自己紹介文です', @user.self_introduction
  end

  test 'can delete a user account' do
    sign_in(@user)

    get edit_user_registration_path
    assert_select 'h2', 'アカウントを編集'

    assert_difference('User.count', -1) do
      delete user_registration_path
    end
  end

  test 'redirect to the login page when not logged in' do
    get books_path
    assert_redirected_to new_user_session_path

    get users_path
    assert_redirected_to new_user_session_path
  end
end
