# frozen_string_literal: true

class Users::UsersController < Devise::RegistrationsController
  def index
    @users = User.order(:id).page(params[:page])
    render :'users/index'
  end

  def show
    @user = User.find_by(id: params[:id])
  end
end
