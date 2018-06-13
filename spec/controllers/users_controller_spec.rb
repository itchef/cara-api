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

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:subscibed_admin_user) {FactoryBot.create(:admin_subscribed_user)}
  let(:secondary_user) {FactoryBot.create(:secondary_user)}
  let(:secondary_unsubscribed_user) {FactoryBot.create(:secondary_unsubscribed_user)}

  after(:all) do
    User.delete_all
  end

  describe "POST create" do
    user = {}
    before(:each) do
      user = {
        username: 'caraUser',
        password: 'password',
        password_confirmation: 'password',
        first_name: 'John',
        last_name: 'Smith',
        is_admin: true
      }
      allow(controller).to receive(:authenticate!).and_return(true)
      allow(controller).to receive(:current_login).and_return({ :user_id =>  subscibed_admin_user[:id]})
    end
    after(:each) do
      User.delete_all
    end
    it 'should successfully add a user' do
      post :create, :params => user
      user = JSON.parse(response.body, {:symbolize_names => true})
      expect(response.content_type).to eq "application/json"
      expect(User.all.size).to eq 2
      expect(user[:first_name]).to eq 'John'
      expect(user[:last_name]).to eq 'Smith'
      expect(user[:username]).to eq 'caraUser'
    end

    it 'should not add a user when mandatory fields are empty' do
      user[:username] = ""
      post :create, :params => user
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.content_type).to eq "application/json"
      error = JSON.parse(response.body, {:symbolize_names => true})
      expect(error[:message]).to eq 'Mandatory Fields are empty'
    end
  end
  describe "PUT #update_password" do
    @user = nil
    before(:each) do
      allow(controller).to receive(:authenticate!).and_return(true)
      allow(controller).to receive(:current_login).and_return({ :user_id =>  subscibed_admin_user[:id]})
    end
    after(:each) do
      User.delete_all
    end

    it 'should update user password successfully for valid arguments' do
      update_password_params = {
        id: subscibed_admin_user[:id],
        password: 'hello',
        password_confirmation: 'hello'
      }
      put :update_password, :params => update_password_params
      expect(response.content_type).to eq "application/json"
      response_data = JSON.parse(response.body, {:symbolize_names => true})
      expect(response_data[:username]).to eq subscibed_admin_user.login.identification
    end

    it 'should not update user password for invalid arguments' do
      update_password_params = {
        id: secondary_user[:id],
        password: '',
        password_confirmation: ''
      }
      put :update_password, :params => update_password_params
      expect(response.content_type).to eq "application/json"
      error = JSON.parse(response.body, {:symbolize_names => true})
      expect(error[:message]).to eq 'Password is missing'
    end
  end
  describe "GET #unsubscribe" do
    before(:each) do
      allow(controller).to receive(:authenticate!).and_return(true)
      allow(controller).to receive(:current_login).and_return({ :user_id =>  subscibed_admin_user[:id]})
      get :unsubscribe, :params => {:id => secondary_user[:id]}
    end
    after(:each) do
      User.delete_all
    end

    it 'should unsubscribe a valid user' do
      expect(response.status).to eq 200
    end

    it 'should show unsucess message during unsubscribe for an unsubscribed user' do
      post :unsubscribe, :params => {:id => secondary_user.id}
      expect(response.status).to eq 400
      error = JSON.parse(response.body, {:symbolize_names => true})
      expect(error[:message]).to eq "#{secondary_user.login[:identification]} is already unsubscribed"
    end
  end

  describe "GET #subscribe" do
    before(:each) do
      allow(controller).to receive(:authenticate!).and_return(true)
      allow(controller).to receive(:current_login).and_return({ :user_id =>  subscibed_admin_user[:id]})
    end
    after(:each) do
      User.delete_all
    end

    it 'should subscribe a valid user' do
      get :subscribe, :params => {:id => secondary_unsubscribed_user.id}
      expect(response.status).to eq 200
    end

    it 'should show unsucess message during subscribe for an subscribed user' do
      get :subscribe, :params => {:id => secondary_user.id}
      expect(response.status).to eq 400
      error = JSON.parse(response.body, {:symbolize_names => true})
      expect(error[:message]).to eq "#{secondary_user.login[:identification]} is already subscribed"
    end
  end

  describe "PUT #admin_status" do
    before(:each) do
      allow(controller).to receive(:authenticate!).and_return(true)
      allow(controller).to receive(:current_login).and_return({ :user_id =>  subscibed_admin_user[:id]})
    end
    after(:each) do
      User.delete_all
    end

    it 'should assign admin status successfully' do
      params = {
        :id => secondary_user[:id],
        :status => true
      }
      put :admin_status, :params => params
      response_data = JSON.parse(response.body, {:symbolize_names => true})
      expect(response_data[:first_name]).to eq(secondary_user[:first_name])
      expect(response_data[:last_name]).to eq(secondary_user[:last_name])
      expect(response_data[:admin]).to be_truthy

      params[:status] = false
      put :admin_status, :params => params
      response_data = JSON.parse(response.body, {:symbolize_names => true})
      expect(response_data[:first_name]).to eq(secondary_user[:first_name])
      expect(response_data[:last_name]).to eq(secondary_user[:last_name])
      expect(response_data[:admin]).to be_falsy
    end

    it 'should throw error when status is same with the user\'s existing status' do
      params = {
        id: secondary_user[:id],
        status: false
      }
      put :admin_status, :params => params
      error = JSON.parse(response.body, {:symbolize_names => true})
      expect(response).to have_http_status(:bad_request)
      expect(error[:message]).to eq "Invalid request. Unable to update admin status."
    end

    it 'should throw error when status is not present on request' do
      params = {
        :id => secondary_user[:id]
      }
      put :admin_status, :params => params
      error = JSON.parse(response.body, {:symbolize_names => true})
      expect(response).to have_http_status(:bad_request)
      expect(error[:message]).to eq "Invalid request. Unable to update admin status."
    end

    it 'should throw error when status is some random text' do
      params = {
        :id => secondary_user[:id],
        :status => "Hello"
      }
      put :admin_status, :params => params
      error = JSON.parse(response.body, {:symbolize_names => true})
      expect(response).to have_http_status(:bad_request)
      expect(error[:message]).to eq "Invalid request. Unable to update admin status."
    end
  end
end
