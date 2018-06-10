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

RSpec.describe MembersController, type: :controller do
  describe "GET #index" do
    before(:each) do
      allow(controller).to receive(:authenticate!).and_return(true)
      FactoryBot.create(:member, :name => "Member 1")
      FactoryBot.create(:member, :name => "Member 2")
    end
    after(:each) do
      Member.delete_all
    end
    it 'should get list of members' do
      get :index
      members = JSON.parse(response.body, {:symbolize_names => true})
      expect(members.size).to be(2)
      expect(Member.all.size).to be(2)
      expect(members[0][:name]).to eq("Member 1")
      expect(members[0][:name]).to eq(Member.find_by(:name => "Member 1")[:name])
      expect(members[0][:contacts]).to be_empty
      expect(members[0][:phone_numbers]).to be_empty
      expect(members[1][:name]).to eq("Member 2")
      expect(members[1][:contacts]).to be_empty
      expect(members[1][:phone_numbers]).to be_empty
    end
  end
  describe "GET #names" do
    before(:each) do
      allow(controller).to receive(:authenticate!).and_return(true)
      FactoryBot.create(:member, :name => "Member 1")
      FactoryBot.create(:member, :name => "Member 2")
    end
    after(:each) do
      Member.delete_all
    end
    it 'should get list of names' do
      get :names
      member_names = JSON.parse(response.body, {:symbolize_names => true})
      expect(member_names.size).to be(2)
      expect(Member.all.size).to be(2)
      expect(member_names[0][:id]).to eq(Member.first[:id])
      expect(member_names[0][:name]).to eq("Member 1")
      expect(member_names[1][:name]).to eq("Member 2")
    end
  end
  describe "GET #show" do
    before(:each) do
      allow(controller).to receive(:authenticate!).and_return(true)
      FactoryBot.create(:member, :name => "Member 1")
      FactoryBot.create(:member, :name => "Member 2")
    end
    after(:each) do
      Member.delete_all
    end
    it 'should get member details' do
      get :show, :params => { id: Member.first[:id] }
      member = JSON.parse(response.body, {:symbolize_names => true})
      expect(member[:name]).to eq("Member 1")
      expect(member[:contacts]).to be_empty
      expect(member[:phone_numbers]).to be_empty
    end
  end
  describe "POST #create" do
    before(:each) do
      allow(controller).to receive(:authenticate!).and_return(true)
    end
    after(:each) do
      Member.delete_all
    end

    it 'should create a member successfully' do
      params = {
        personal: {
          name: Faker::Name.name,
          age: 10,
          place: Faker::Address.city,
          photo_url: "SOME_URL"
        }
      }
      post :create, :params => params
      member = JSON.parse(response.body, {:symbolize_names => true})
      expect(member[:name]).to eq(params[:personal][:name])
      expect(Member.first[:name]).to eq(params[:personal][:name])
    end
    it 'should throw error when name is not present' do
      params = {
        personal: {
          name: "",
          age: 10,
          place: Faker::Address.city,
          photo_url: "SOME_URL"
        }
      }
      post :create, :params => params
      error = JSON.parse(response.body, {:symbolize_names => true})
      expect(error[:message]).to eq("Request Error. Member name / age / place can not be null.")
      expect(response).to have_http_status(:bad_request)
    end
    it 'should throw error when age is not present' do
      params = {
        personal: {
          name: Faker::Name.name,
          age: "",
          place: Faker::Address.city,
          photo_url: "SOME_URL"
        }
      }
      post :create, :params => params
      error = JSON.parse(response.body, {:symbolize_names => true})
      expect(error[:message]).to eq("Request Error. Member name / age / place can not be null.")
      expect(response).to have_http_status(:bad_request)
    end
    it 'should throw error when place is not present' do
      params = {
        personal: {
          name: Faker::Name.name,
          age: 10,
          place: "",
          photo_url: "SOME_URL"
        }
      }
      post :create, :params => params
      error = JSON.parse(response.body, {:symbolize_names => true})
      expect(error[:message]).to eq("Request Error. Member name / age / place can not be null.")
      expect(response).to have_http_status(:bad_request)
    end
  end
  describe "PUT #update" do
    before(:each) do
      allow(controller).to receive(:authenticate!).and_return(true)
      FactoryBot.create(:member)
    end
    after(:each) do
      Member.delete_all
    end

    it 'should update an existing user record' do
      params = {
        id: Member.first[:id],
        personal: {
          name: "Member 1"
        }
      }
      put :update, :params => params
      member = JSON.parse(response.body, {:symbolize_names => true})
      expect(member[:name]).to eq("Member 1")
      expect(Member.first[:name]).to eq("Member 1")
    end
  end
  describe "DELETE #destroy" do
    before(:each) do
      allow(controller).to receive(:authenticate!).and_return(true)
      FactoryBot.create(:member)
    end
    after(:each) do
      Member.delete_all
    end

    it 'should update an existing user record' do
      params = {
        id: Member.first[:id]
      }
      expected_member_name = Member.first[:name]
      expect(Member.all.size).to eq(1)
      delete :destroy, :params => params
      member = JSON.parse(response.body, {:symbolize_names => true})
      expect(Member.all.size).to eq(0)
      expect(member[:name]).to eq(expected_member_name)
    end
  end
  describe "Unauthorized access" do
    it 'should not get list of members' do
      expect(get :index).to have_http_status(:unauthorized)
    end
    it 'should not get list of members name' do
      expect(get :names).to have_http_status(:unauthorized)
    end
    it 'should not get member' do
      expect(get :show, :params => { id: 1 }).to have_http_status(:unauthorized)
    end
    it 'should not create a member' do
      expect(post :create).to have_http_status(:unauthorized)
    end
    it 'should not update a member' do
      expect(put :update, :params => { id: 1 }).to have_http_status(:unauthorized)
    end
    it 'should not delete a member' do
      expect(delete :destroy, :params => { id: 1 }).to have_http_status(:unauthorized)
    end
  end
end
