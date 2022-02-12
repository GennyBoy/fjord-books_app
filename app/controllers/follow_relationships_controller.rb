# frozen_string_literal: true

class FollowRelationshipsController < ApplicationController
  # TODO: user をセットする処理を共通化して、before_actionにする

  def create
    user = User.find(params[:followed_id])
    current_user.follow(user)
    redirect_to user
  end

  def destroy
    user = User.find(params[:id])
    current_user.unfollow(user)
    redirect_to user
  end

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
