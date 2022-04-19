# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    @login_user = users(:alice)
    visit root_url
    fill_in 'Eメール', with: @login_user.email
    fill_in 'パスワード', with: 'password'
    click_on 'ログイン'
  end

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
    report_to_edit = create(:report, user: @login_user)
    visit reports_url
    click_on '編集', exact: true, match: :first

    # 更新されていることを確かにするため、最初の入力値も確認しておく
    assert "#report_title[value='#{report_to_edit.title}']"
    assert "#report_content[value='#{report_to_edit.content}']"

    fill_in 'タイトル', with: 'Aliceの編集後レポートのタイトル'
    fill_in '内容', with: 'Aliceの編集後のレポートの内容'
    click_on '更新する'

    assert_text '日報が更新されました。'
    assert_text 'Aliceの編集後レポートのタイトル'
    assert_text 'Aliceの編集後のレポートの内容'
  end

  test '日報を削除する' do
    report_to_delete = create(:report, user: @login_user)
    visit reports_url

    assert_text report_to_delete.title

    page.accept_confirm do
      click_on '削除', match: :first
    end

    assert_text '日報が削除されました。'

    assert_no_text report_to_delete.title
  end
end
