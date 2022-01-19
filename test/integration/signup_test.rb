# frozen_string_literal: true

require 'test_helper'

class SignupTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def after_teardown
    super
    FileUtils.rm_rf(ActiveStorage::Blob.service.root)
  end

  test 'can signup' do
    assert_difference('User.count', 1) do
      post user_registration_path,
           params: {
             user: {
               name: 'test user',
               avatar: fixture_file_upload('david.png', 'image/png'),
               email: 'test3@example.com',
               password: 'password',
               password_confirmation: 'password'
             }
           }
    end
    user = User.order(:created_at).last
    # 今回のプラクティスの要件のテスト
    assert user.avatar.attached?
  end
end
