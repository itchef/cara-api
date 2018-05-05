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
    describe "POST create" do
        user = {}
        before(:each) do
            user = {
                username: 'caraUser',
                password: 'password',
                password_confirmation: 'password',
                first_name: 'John',
                last_name: 'Smith'
            }
        end
        after(:each) do
            User.delete_all
        end
        it 'should successfully add a user' do
            post :create, :params => user
            user = JSON.parse(response.body, {:symbolize_names => true})
            expect(response.content_type).to eq "application/json"
            expect(User.all.size).to eq 1
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
            user = {
                username: 'caraUser',
                password: 'password',
                password_confirmation: 'password',
                first_name: 'John',
                last_name: 'Smith'
            }
            post :create, :params => user
            @user = JSON.parse(response.body, {:symbolize_names => true})
        end
        after(:each) do
            User.delete_all
        end

        it 'should update user password successfully for valid arguments' do
            update_password_params = {
                id: @user[:id],
                password: 'hello',
                password_confirmation: 'hello'
            }
            put :update_password, :params => update_password_params
            expect(response.content_type).to eq "application/json"
            response_data = JSON.parse(response.body, {:symbolize_names => true})
            expect(response_data[:message]).to eq "Password is successfully updated"
            expect(response_data[:user][:username]).to eq @user[:username]
        end

        it 'should not update user password for invalid arguments' do
            update_password_params = {
                id: @user[:id],
                password: '',
                password_confirmation: ''
            }
            put :update_password, :params => update_password_params
            expect(response.content_type).to eq "application/json"
            error = JSON.parse(response.body, {:symbolize_names => true})
            expect(error[:message]).to eq 'Password is missing'
        end
    end
end