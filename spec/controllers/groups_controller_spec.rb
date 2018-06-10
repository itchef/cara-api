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

RSpec.describe GroupsController, type: :controller do

  describe "GET #index" do
    before(:each) do
      allow(controller).to receive(:authenticate!).and_return(true)
      FactoryBot.create(:group, :name => "Group 1")
      FactoryBot.create(:group, :name => "Group 2")
      FactoryBot.create(:member, :name => "Member_1")
      FactoryBot.create(:group_member_map,
                        :member => Member.find_by(:name => "Member_1"),
                        :group => Group.find_by(:name => "Group 1"))
    end
    after(:each) do
      GroupMemberMap.delete_all
      Group.delete_all
      Member.delete_all
    end
    it 'should get all group list' do
      get :index
      groups = JSON.parse(response.body, {:symbolize_names => true})
      expect(groups.size).to eq(2)
      expect(groups[0][:name]).to eq("Group 1")
      expect(groups[0][:members].size).to eq(1)
      expect(groups[0][:members][0][:name]).to eq("Member_1")
    end
  end
  describe "POST #create" do
    before(:each) do
      allow(controller).to receive(:authenticate!).and_return(true)
    end
    after(:each) do
      Group.delete_all
    end
    it 'should create a group successfully' do
      params = {
        group: {
          name: "Group 1",
          description: Faker::Lorem.sentence
        }
      }
      post :create, :params => params
      group = JSON.parse(response.body, {:symbolize_names => true})
      expect(group[:name]).to eq(params[:group][:name])
      expect(group[:name]).to eq(Group.find_by(:name => "Group 1")[:name])
    end
    it 'should render error message when group description is not present' do
      params = {
        group: {
          name: "Group 1",
          description: ""
        }
      }
      post :create, :params => params
      error = JSON.parse(response.body, {:symbolize_names => true})
      expect(response).to have_http_status(:bad_request)
      expect(error[:message]).to eq("Request Error. Group name / description can not be blank")
    end

    it 'should render error message when group name is not present' do
      params = {
        group: {
          name: "",
          description: Faker::Lorem.sentence
        }
      }
      post :create, :params => params
      error = JSON.parse(response.body, {:symbolize_names => true})
      expect(response).to have_http_status(:bad_request)
      expect(error[:message]).to eq("Request Error. Group name / description can not be blank")
    end
  end
  describe "post #assign_member" do
    let(:group) { FactoryBot.create(:group, :name => "Group 1") }
    let(:member) { FactoryBot.create(:member) }

    before(:each) do
      allow(controller).to receive(:authenticate!).and_return(true)
    end
    after(:each) do
      GroupMemberMap.delete_all
      Member.delete_all
      Group.delete_all
    end
    it 'should assign a member to a group' do
      params = {
        group_id: group[:id],
        member_id: member[:id]
      }
      post :assign_member, :params => params
      response_data = JSON.parse(response.body, {:symbolize_names => true})
      expect(response_data[:group][:name]).to eq("Group 1")
      expect(response_data[:group][:members][0][:name]).to eq(member[:name])
      expect(response_data[:member][:name]).to eq(member[:name])
      expect(Member.find(GroupMemberMap.first[:member_id])[:name]).to eq(member[:name])
      expect(Group.find(GroupMemberMap.first[:group_id])[:name]).to eq(group[:name])
    end
    it 'should render error message when member is already assign to a group' do
      FactoryBot.create(:group_member_map, :member_id => member[:id], :group_id => group[:id])
      params = {
        group_id: group[:id],
        member_id: member[:id]
      }
      post :assign_member, :params => params
      error = JSON.parse(response.body, {:symbolize_names => true})
      expect(response).to have_http_status(:bad_request)
      expect(error[:message]).to eq("Member is already assigned to group")
    end
  end
  describe "post #unassign_member" do
    let(:group) { FactoryBot.create(:group, :name => "Group 1") }
    let(:member) { FactoryBot.create(:member) }

    before(:each) do
      allow(controller).to receive(:authenticate!).and_return(true)
      FactoryBot.create(:group_member_map, :member_id => member[:id], :group_id => group[:id])
    end
    after(:each) do
      GroupMemberMap.delete_all
      Member.delete_all
      Group.delete_all
    end
    it 'should unassign a member from a group' do
      params = {
        group_id: group[:id],
        member_id: member[:id]
      }
      delete :unassigned_member, :params => params
      response_data = JSON.parse(response.body, {:symbolize_names => true})
      expect(response_data[:name]).to eq(member[:name])
      expect(GroupMemberMap.all.size).to be(0)
    end
    it 'should render error message when member is already unassigned from a group' do
      GroupMemberMap.find_by(:member_id => member[:id], :group_id => group[:id]).destroy
      params = {
        group_id: group[:id],
        member_id: member[:id]
      }
      delete :unassigned_member, :params => params
      error = JSON.parse(response.body, {:symbolize_names => true})
      expect(response).to have_http_status(:bad_request)
      expect(error[:message]).to eq("Member is unable to unassigned")
    end
  end
  describe "unauthorised user" do
    let(:group) { FactoryBot.create(:group, :name => "Group 1") }
    let(:member) { FactoryBot.create(:member) }

    it 'should not get groups' do
      expect(get :index).to have_http_status(:unauthorized)
    end
    it 'should not create group' do
      expect(post :create).to have_http_status(:unauthorized)
    end
    it 'should not assign member to a group' do
      expect(post :assign_member).to have_http_status(:unauthorized)
    end
    it 'should not unassign member from a group' do
      params = {
        group_id: group[:id],
        member_id: member[:id]
      }
      expect(delete :unassigned_member, :params => params).to have_http_status(:unauthorized)
    end
  end
end
