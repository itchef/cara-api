# Cara API is Rest APIs for Cara application which is a face cheat book for organisation
# Copyright  (C) 2018  ITChef
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see [https://www.gnu.org/licenses/](https://www.gnu.org/licenses/).

# @author: Kaustav Chakraborty (@phoenixTW)

class UsersController < ApplicationController
  include RailsApiAuth::Authentication
  include UserHelper
  include AbilityHelper

  before_action :authenticate!
  before_action :set_user, only: [:update_password, :unsubscribe, :subscribe, :admin_status, :archive]

  def index
    can_manage?
    render json: User.all.where(:is_archived => false).map {|user| Oprah.present(user).json}
  end

  def create
    can_manage?
    user = User.new(user_params)
    if user.valid? && is_sign_up_params_present?(login_params)
      user.save && user.create_login(login_params)
      render json: Oprah.present(user).json
    else
      render json:
               {message: 'Mandatory Fields are empty'},
             :status => :unprocessable_entity
    end
  end

  def update_password
    can_manage?
    if @user && is_password_params_present?(password_params) && passwords_matched?(password_params)
      @user.login.update_attribute(:password, password_params[:password])
      render json: Oprah.present(@user).json
    else
      render json: {message: "Password is missing"}, :status => :unprocessable_entity
    end
  end

  def subscribe
    can_manage?
    if @user[:is_unsubscribed]
      @user.update_attribute(:is_unsubscribed, false)
      render json: Oprah.present(@user).json
    else
      render json: {message: "#{@user.login.identification} is already subscribed"}, :status => :bad_request
    end
  end

  def unsubscribe
    can_manage?
    unless @user[:is_unsubscribed]
      @user.update_attribute(:is_unsubscribed, true)
      render json: Oprah.present(@user).json
    else
      render json: {message: "#{@user.login.identification} is already unsubscribed"}, :status => :bad_request
    end
  end

  def recent
    render json: Oprah.present(User.find(current_login[:user_id])).recent
  end

  def admin_status
    can_manage?
    if (is_boolean_type_value_present params[:status]) and @user[:is_admin] != to_bool(params[:status])
      @user.update_attribute(:is_admin, params[:status])
      render json: Oprah.present(@user).json
    else
      render json: {message: "Invalid request. Unable to update admin status."}, :status => :bad_request
    end
  end

  def archive
    can_manage?
    if @user[:is_archived]
      render json: {message: "#{@user[:first_name]} #{@user[:last_name]} is already archived"}, :status => :bad_request
    elsif @user.update_attributes(:is_archived => true, :is_unsubscribed => true)
      render json: Oprah.present(@user).json
    else
      render json: {message: "Unable to archive user"}, :status => :bad_request
    end
  end

  private

  def is_boolean_type_value_present(bool)
    (bool.to_s.downcase === "true") or (bool.to_s.downcase === "false")
  end

  def to_bool(val)
    if val.to_s.downcase == "true"
      true
    else
      false
    end
  end

  def user_params
    params.permit(:first_name, :last_name, :is_admin)
  end

  def password_params
    params.permit(:password, :password_confirmation)
  end

  def login_params
    sign_up_params = params.permit(:password, :password_confirmation)
    sign_up_params[:identification] = params[:username]
    sign_up_params
  end

  def set_user
    @user = User.find(params[:id])
  end
end
