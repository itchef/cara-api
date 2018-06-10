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

RSpec.describe ContactSourceMemberMap, type: :model do
  describe "get_contact_list_for" do
    before(:each) do
      FactoryBot.create(:contact_source, :name => "email")
      FactoryBot.create(:contact_source, :name => "phone")
      FactoryBot.create(:member, :name => "Member 1")
      FactoryBot.create(:contact_source_member_map,
                        :member => Member.first,
                        :contact_source => ContactSource.find_by(:name => "email"),
                        :value => Faker::Internet.email)

      FactoryBot.create(:contact_source_member_map,
                        :member => Member.first,
                        :contact_source => ContactSource.find_by(:name => "phone"),
                        :value => Faker::Number.number(10))
    end

    after(:each) do
      ContactSourceMemberMap.delete_all
      ContactSource.delete_all
      Member.delete_all
    end
    it 'should get contact list' do
      contacts = ContactSourceMemberMap.get_contact_list_for(Member.first[:id])
      expect(contacts.size).to be(1)
      expect(contacts.first[:name]).to eq("email")
      expect(contacts.first[:value]).to eq(ContactSourceMemberMap.first[:value])
    end
  end
  describe "get_phone_numbers" do
    before(:each) do
      FactoryBot.create(:contact_source, :name => "email")
      FactoryBot.create(:contact_source, :name => "phone")
      FactoryBot.create(:member, :name => "Member 1")
      FactoryBot.create(:contact_source_member_map,
                        :member => Member.first,
                        :contact_source => ContactSource.find_by(:name => "email"),
                        :value => Faker::Internet.email)

      FactoryBot.create(:contact_source_member_map,
                        :member => Member.first,
                        :contact_source => ContactSource.find_by(:name => "phone"),
                        :value => Faker::Number.number(10))
    end

    after(:each) do
      ContactSourceMemberMap.delete_all
      ContactSource.delete_all
      Member.delete_all
    end
    it 'should get contact list' do
      contacts = ContactSourceMemberMap.get_phone_numbers(Member.first[:id])
      expect(contacts.size).to be(1)
      expect(contacts.first[:name]).to eq("phone")
      expect(contacts.first[:value]).to eq(ContactSourceMemberMap.last[:value])
    end
  end
  describe "get_all_contact_list_for" do
    before(:each) do
      FactoryBot.create(:contact_source, :name => "email")
      FactoryBot.create(:contact_source, :name => "phone")
      FactoryBot.create(:member, :name => "Member 1")
      FactoryBot.create(:contact_source_member_map,
                        :member => Member.first,
                        :contact_source => ContactSource.find_by(:name => "email"),
                        :value => Faker::Internet.email)

      FactoryBot.create(:contact_source_member_map,
                        :member => Member.first,
                        :contact_source => ContactSource.find_by(:name => "phone"),
                        :value => Faker::Number.number(10))
    end

    after(:each) do
      ContactSourceMemberMap.delete_all
      ContactSource.delete_all
      Member.delete_all
    end
    it 'should get contact list' do
      contacts = ContactSourceMemberMap.get_all_contact_list_for(Member.first[:id])
      expect(contacts.size).to be(2)
      expect(contacts.first[:name]).to eq("email")
      expect(contacts.first[:value]).to eq(ContactSourceMemberMap.first[:value])
      expect(contacts.last[:name]).to eq("phone")
      expect(contacts.last[:value]).to eq(ContactSourceMemberMap.last[:value])
    end
  end
end
