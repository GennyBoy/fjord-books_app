# frozen_string_literal: true

class FollowRelationshipsController < ApplicationController
  def following
    @title = 'フォロー中'
    @user = User.find(params[:id])
    @users = @user.following.order(:id).page(params[:page])
    render 'users/show_follow'
  end

  def followers
    @title = 'フォロワー'
    @user = User.find(params[:id])
    @users = @user.followers.order(:id).page(params[:page])
    render 'users/show_follow'
  end
end
