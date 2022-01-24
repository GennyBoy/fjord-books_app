# frozen_string_literal: true

require 'test_helper'

class EditUserTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
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
end
