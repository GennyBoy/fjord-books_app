# frozen_string_literal: true

class Users::FollowingController < ApplicationController
  def index
    user = User.find(params[:user_id])
    @users = user.following.order(:id).page(params[:page])
    render 'users/show_follow'
  end
end
