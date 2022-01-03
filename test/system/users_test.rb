# frozen_string_literal: true

require 'application_system_test_case'

class UsersTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
  end

  test 'creating a user account' do
    visit new_user_registration_url

    fill_in 'Eメール', with: 'test100@example.com'

    fill_in 'パスワード', with: 'password'
    fill_in 'パスワード（確認用）', with: 'password'

    fill_in '郵便番号', with: '111-1111'
    fill_in '住所', with: '東京都東京東京村1-1-1'

    fill_in '自己紹介', with: 'こんにちは、はじめまして。'

    click_button 'アカウント登録'

    assert_current_path root_path
    assert_text 'アカウント登録が完了しました。'
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

  test 'editing a user account' do
    sign_in @user

    visit edit_user_registration_url

    fill_in 'Eメール', with: 'test1_edit@example.com'
    fill_in 'パスワード', with: 'password_edit'
    fill_in 'パスワード（確認用）', with: 'password_edit'
    fill_in '郵便番号', with: '222-2222'
    fill_in '住所', with: '東京都東京区東京1-1-2'
    fill_in '自己紹介', with: 'これは編集後の自己紹介文です。'

    fill_in '現在のパスワード', with: 'password'
    click_on '更新'

    assert_current_path edit_user_registration_path
    assert_text 'アカウント情報を変更しました。'
  end

  test 'unable to edit a user account with leaving current password blank' do
    sign_in @user

    visit edit_user_registration_url

    fill_in 'Eメール', with: 'test1_edit@example.com'
    fill_in 'パスワード', with: 'password_edit'
    fill_in 'パスワード（確認用）', with: 'password_edit'
    fill_in '郵便番号', with: '222-2222'
    fill_in '住所', with: '東京都東京区東京1-1-2'
    fill_in '自己紹介', with: 'これは編集後の自己紹介文です。'

    # 現在のパスワードの入力欄に何も入力せずに更新をクリックする
    click_on '更新'

    assert_text '現在のパスワードを入力してください'
  end

  test 'unable to edit a user account with wrong current password' do
    sign_in @user

    visit edit_user_registration_url

    fill_in 'Eメール', with: 'test1_edit@example.com'
    fill_in 'パスワード', with: 'password_edit'
    fill_in 'パスワード（確認用）', with: 'password_edit'
    fill_in '郵便番号', with: '222-2222'
    fill_in '住所', with: '東京都東京区東京1-1-2'
    fill_in '自己紹介', with: 'これは編集後の自己紹介文です。'

    fill_in '現在のパスワード', with: 'wrong_password'
    click_on '更新'

    assert_text '現在のパスワードは不正な値です'
  end

  test 'visiting the user index' do
    sign_in @user

    visit users_url
    assert_selector 'h1', text: 'ユーザー'
  end

  test 'visiting the user page' do
    sign_in @user

    visit users_url
    click_link id: 'show_user', match: :first

    assert_text 'Eメール: test1@example.com'
    assert_text '郵便番号: 111-1111'
    assert_text '住所: 東京都東京区東京1-1-1'
    assert_text '自己紹介: これは自己紹介文です。'
  end

  test 'destroying a user' do
    sign_in @user

    visit edit_user_registration_url

    page.accept_confirm do
      click_button 'アカウントを削除する'
    end

    assert_current_path new_user_session_path
    assert_text 'アカウント登録もしくはログインしてください。'
  end

  test 'redirected to login page when not logged in' do
    visit users_url
    assert_current_path new_user_session_path
  end
end
