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

RSpec.describe Group, type: :model do
  describe "validations" do
    after(:each) do
      Group.delete_all
    end
    it 'should throw error when name is not present' do
      member = Group.create(:name => "", :description => Faker::Lorem.sentence)
      expect(member.valid?).to be_falsy
      expect(member.errors.messages).to eq({ :name=> ["can't be blank"] })
    end

    it 'should throw uniqueness validation error when group name is duplicated' do
      Group.create(:name => "Group 1", :description => Faker::Lorem.sentence)
      group = Group.new(:name => "Group 1", :description => Faker::Lorem.sentence)
      expect(group).to_not be_valid
    end
  end

  describe "get_assigned_members_list" do
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
    it 'should get list of assigned members' do
      members = Group.get_assigned_members_list(Group.first[:id])
      expect(members.size).to be(1)
      expect(members[0]).to eq(Member.first)
      FactoryBot.create(:group, :name => "Group 2")
      expect(Group.get_assigned_members_list(Group.last[:id])).to be_empty
    end
  end
  describe "get_assigned_members_list_with_full_data" do
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
    it 'should get list of assigned members with full data' do
      members = Group.get_assigned_members_list_with_full_data(Group.first[:id])
      expect(members.size).to be(1)
      expect(members[0]).to eq(Member.first)
      FactoryBot.create(:group, :name => "Group 2")
      expect(Group.get_assigned_members_list_with_full_data(Group.last[:id])).to be_empty
    end
  end
end
