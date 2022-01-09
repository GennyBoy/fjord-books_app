# frozen_string_literal: true

require 'test_helper'

class Users::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
  end

  test 'should create a user with valid params' do
    assert_difference('User.count', 1) do
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
    end
  end

  test 'should not create a user with invalid params' do
    assert_no_difference('User.count') do
      post user_registration_path,
           params: {
             user: {
               email: '', # blank email is invalid
               password: 'password',
               password_confirmation: 'password',
               post_code: '222-2222',
               address: '千葉県千葉市1-1-1',
               self_introduction: 'This is my self intro'
             }
           }
    end
  end

  test 'should update a user with valid params' do
    sign_in(@user)

    patch user_registration_path,
          params: {
            user: {
              email: 'test2@example.com',
              post_code: '222-2222',
              address: '千葉県千葉市1-1-1',
              self_introduction: 'This is my self intro',
              current_password: 'password'
            }
          }
    assert_redirected_to edit_user_registration_path

    @user.reload
    assert_equal 'test2@example.com', @user.email
    assert_equal '222-2222', @user.post_code
    assert_equal '千葉県千葉市1-1-1', @user.address
    assert_equal 'This is my self intro', @user.self_introduction
  end

  test 'should not update a user with invalid params' do
    sign_in(@user)

    patch user_registration_path,
          params: {
            user: {
              email: '',
              post_code: '222-2222',
              address: '千葉県千葉市1-1-1',
              self_introduction: 'This is my self intro',
              current_password: 'password'
            }
          }
    assert_response :success

    @user.reload
    assert_equal users(:one).email, @user.email
    assert_equal users(:one).post_code, @user.post_code
    assert_equal users(:one).address, @user.address
    assert_equal users(:one).self_introduction, @user.self_introduction
  end
end
