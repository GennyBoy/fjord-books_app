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

    post user_registration_path,
         params: {
           user: {
             email: 'test2@example.com',
             password: 'password',
             password_confirmation: 'password',
             post_code: '222-2222',
             address: '千葉県千葉市1-1-1',
             self_introduction: 'This is my self intro'
           }
         }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'p', 'アカウント登録が完了しました。'
  end

  test 'cannot create a user account when password_confirmation is wrong' do
    post user_registration_path,
         params: {
           user: {
             email: 'test2@example.com',
             password: 'password',
             password_confirmation: 'wrong_password',
             post_code: '222-2222',
             address: '千葉県千葉市1-1-1',
             self_introduction: 'This is my self intro'
           }
         }
    assert_response :success
    assert_select 'h2', 'エラーが発生したため ユーザー は保存されませんでした:'
    assert_select 'li', 'パスワード（確認用）とパスワードの入力が一致しません'
  end

  test 'cannot create a user account when email is blank' do
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
    assert_response :success
    assert_select 'h2', 'エラーが発生したため ユーザー は保存されませんでした:'
    assert_select 'li', 'Eメールを入力してください'
  end

  test 'can send an instruction of resetting password' do
    get new_user_password_path
    assert_select 'h2', 'パスワードを忘れた方'

    post user_password_path,
         params: {
           user: {
             email: 'test1@example.com'
           }
         }
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
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'p', 'アカウント情報を変更しました。'
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
  end

  test 'can delete a user account' do
    sign_in(@user)

    get edit_user_registration_path
    assert_select 'h2', 'アカウントを編集'

    delete user_registration_path
    assert_response :redirect
    follow_redirect!
    assert_select 'p', 'アカウント登録もしくはログインしてください。'
  end

  test 'can see the index page' do
    # TODO
  end

  test 'can see the user show page' do
    # TODO
  end

  test 'redirect to the login page when not logged in' do
    # TODO
  end
end
