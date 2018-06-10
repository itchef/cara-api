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
require 'database_cleaner'

RSpec.describe DashboardController, type: :controller do

  describe "GET #index" do
    def generate_bulk_data
      FactoryBot.create(:member, :name => "Member_1")
      FactoryBot.create(:member, :name => "Member_2")
      FactoryBot.create(:member, :name => "Member_3")
      FactoryBot.create(:member, :name => "Member_4")

      FactoryBot.create(:group, :name => "Group 1")
      FactoryBot.create(:group, :name => "Group 2")

      FactoryBot.create(:group_member_map, :member => Member.find_by(:name => "Member_1"), :group => Group.find(1))
      FactoryBot.create(:group_member_map, :member => Member.find_by(:name => "Member_2"), :group => Group.find(1))
      FactoryBot.create(:group_member_map, :member => Member.find_by(:name => "Member_3"), :group => Group.find(2))
    end

    before(:each) do
      allow(controller).to receive(:authenticate!).and_return(true)
      generate_bulk_data
    end
    after(:each) do
      GroupMemberMap.delete_all
      Member.delete_all
      Group.delete_all
    end

    it 'should get dashboard specific groups and member list' do
      get :index
      dashboard_groups = JSON.parse(response.body, {:symbolize_names => true})
      expect(dashboard_groups.size).to eq(3)
      expect(dashboard_groups[0][:name]).to eq("Unassigned")
      expect(dashboard_groups[1][:name]).to eq("Group 1")
      expect(dashboard_groups[2][:name]).to eq("Group 2")
      expect(dashboard_groups[0][:members].size).to eq(1)
      expect(dashboard_groups[0][:members][0][:name]).to eq("Member_4")
      expect(dashboard_groups[1][:members][0][:name]).to eq("Member_1")
      expect(dashboard_groups[1][:members][1][:name]).to eq("Member_2")
      expect(dashboard_groups[2][:members][0][:name]).to eq("Member_3")
    end
  end
  describe "unauthorised user" do
    it 'should send error when accessing dashboard member groups' do
      get :index
      expect(response.status).to be(401)
    end
  end
end
