# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @me = users(:bob)
    @she = users(:alice)
  end

  test '#following?' do
    assert_not @me.following?(@she)
    @me.follow(@she)
    assert @me.following?(@she)
  end

  test '#followed_by?' do
    assert_not @she.followed_by?(@me)
    @me.follow(@she)
    assert @she.followed_by?(@me)
  end

  test '#follow' do
    assert_not @me.following?(@she)
    @me.follow(@she)
    assert @me.following?(@she)
  end

  test '#unfollow' do
    @me.follow(@she)

    @me.unfollow(@she)
    assert_not @me.following?(@she)
  end

  test '#name_or_email' do
    user = User.new(email: 'foo@example.com', name: '')
    assert_equal 'foo@example.com', user.name_or_email

    user.name = 'Foo Bar'
    assert_equal 'Foo Bar', user.name_or_email
  end
end
