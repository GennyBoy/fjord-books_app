# frozen_string_literal: true

class FollowRelationshipsController < ApplicationController
  def following
    @user = User.find(params[:id])
    @users = @user.following.order(:id).page(params[:page])
    render 'users/show_follow'
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followers.order(:id).page(params[:page])
    render 'users/show_follow'
  end
end
