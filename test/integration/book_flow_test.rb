# frozen_string_literal: true

require 'test_helper'

class BookFlowTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:one)
    @book = books(:one)
  end

  test 'can see the index page' do
    get root_path
    assert_response :success
    assert_select 'h1', '本'
  end

  test 'can see the book show page' do
    get book_path(@book)
    assert_response :success
  end

  test 'can see the book edit page' do
    get edit_book_path(@book)
    assert_response :success
    assert_select 'h1', '本の編集'
  end

  test 'can create a Book' do
    post books_path,
         params: {
           book: {
             title: 'New Title',
             memo: 'New Memo'
           }
         }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'p', '本が作成されました。'
  end

  test 'can update a Book' do
    patch book_path(@book),
          params: {
            book: {
              title: 'Edited Title',
              memo: 'Edited Memo'
            }
          }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'p', '本が更新されました。'
  end

  test 'can delete a Book' do
    delete book_path(@book)
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'p', '本が削除されました。'
  end
end
