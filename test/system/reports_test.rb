# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    visit root_url
    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_on 'ログイン'
  end

  # メールアドレスとパスワードでログインして日報を書く、
  # という一連の流れをシステムテストで書く
  # 日報の編集や日報の削除もテストコードを書く
  test '日報を作成する' do
    visit reports_url
    click_on '新規作成'

    fill_in 'タイトル', with: '日報作成テストのタイトル'
    fill_in '内容', with: <<~TEXT
      日報作成テストの内容一行目
      日報作成テストの内容二行目
    TEXT
    click_on '登録する'

    assert_text '日報作成テストのタイトル'
    assert_text <<~TEXT
      日報作成テストの内容一行目
      日報作成テストの内容二行目
    TEXT
    assert_text 'alice'
    assert_text I18n.localize(Time.zone.today)
  end

  test '日報を編集する' do
    # TODO 後でここのテストデータを FactoryBotに置き換える
    visit reports_url
    click_on '編集', exact: true, match: :first

    fill_in 'タイトル', with: 'Aliceの編集後レポートのタイトル'
    fill_in '内容', with: 'Aliceの編集後のレポートの内容'
    click_on '更新する'

    assert_text '日報が更新されました。'
    assert_text 'Aliceの編集後レポートのタイトル'
    assert_text 'Aliceの編集後のレポートの内容'
  end

  test '日報を削除する' do
    # TODO 後でここのテストデータを FactoryBotに置き換える
    visit reports_url
    page.accept_confirm do
      click_on '削除', match: :first
    end

    assert_text '日報が削除されました。'
  end
end
