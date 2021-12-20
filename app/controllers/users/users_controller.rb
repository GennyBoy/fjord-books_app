# frozen_string_literal: true

class Users::UsersController < Devise::RegistrationsController
  def index
    @users = User.order(:id).page(params[:page])
    render :'devise/users/index'
  end
end
