# frozen_string_literal: true

class Users::UsersController < ApplicationController
  def index
    @users = User.order(:id).page(params[:page])
    render 'users/index'
  end

  def show
    @user = User.find_by(id: params[:id])
    render 'users/show'
  end
end
