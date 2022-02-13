# frozen_string_literal: true

class Users::FollowersController < ApplicationController
  def index
    user = User.find(params[:user_id])
    @users = user.followers.order(:id).page(params[:page])
    render 'users/show_follow'
  end
end
