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

RSpec.describe GroupMemberMap, type: :model do
  describe "get_all_assigned_members" do
    before(:each) do
      FactoryBot.create(:member, :name => "Member 1")
      FactoryBot.create(:group, :name => "Group 1")
      FactoryBot.create(:group_member_map, :member => Member.first, :group => Group.first)
    end
    after(:each) do
      GroupMemberMap.delete_all
      Member.delete_all
      Group.delete_all
    end

    it 'should get all assigned members' do
      all_assigned_members = GroupMemberMap.get_all_assigned_members
      expect(all_assigned_members.size).to be(1)
      expect(all_assigned_members[0]).to eq(Member.first)
    end
  end
end
