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

RSpec.describe ContactsController, type: :controller do

  let(:subscibed_admin_user) {FactoryBot.create(:admin_subscribed_user)}
  let(:member) {FactoryBot.create(:member)}
  let(:email) {FactoryBot.create(:contact_source, :name => "email")}
  let(:phone) {FactoryBot.create(:contact_source, :name => "phone")}

  describe "POST #add_contacts" do
    contacts_params = []
    before(:each) do
      allow(controller).to receive(:authenticate!).and_return(true)
      allow(controller).to receive(:can_manage?).and_return(true)
      contacts_params = [
        { name: email[:name], value: Faker::Internet.email },
        { name: phone[:name], value: Faker::Number.number(10) }
      ]
    end
    after(:each) do
      ContactSourceMemberMap.delete_all
      ContactSource.delete_all
      Member.delete_all
    end

    it "should create contacts successfully" do
      params = {
        member_id: member.id,
        contacts: contacts_params
      }
      post :add_contacts, :params => params
      contacts = JSON.parse(response.body, {:symbolize_names => true})
      expect(contacts.size).to be(2)
      expect(contacts[0][:name]).to eq('email')
      expect(contacts[0][:value]).to eq(contacts_params[0][:value])
      expect(contacts[1][:name]).to eq('phone')
      expect(contacts[1][:value]).to eq(contacts_params[1][:value])
    end
    it 'should update already existed contact' do
      ContactSourceMemberMap.create(:contact_source => email, :value => Faker::Internet.email, :member => member)
      params = {
        member_id: member.id,
        contacts: contacts_params
      }
      post :add_contacts, :params => params
      contacts = JSON.parse(response.body, {:symbolize_names => true})
      expect(contacts.size).to be(2)
      expect(contacts[0][:name]).to eq('email')
      expect(contacts[0][:value]).to eq(contacts_params[0][:value])
      expect(contacts[1][:name]).to eq('phone')
      expect(contacts[1][:value]).to eq(contacts_params[1][:value])
    end
    it 'should delete contact when value is blank' do
      ContactSourceMemberMap.create(:contact_source => email, :value => Faker::Internet.email)
      contacts_params[0][:value] = ""
      params = {
        member_id: member.id,
        contacts: contacts_params
      }
      post :add_contacts, :params => params
      contacts = JSON.parse(response.body, {:symbolize_names => true})
      expect(contacts.size).to be(1)
      expect(contacts[0][:name]).to eq('phone')
      expect(contacts[0][:value]).to eq(contacts_params[1][:value])
    end
    it 'should not create any contact when value is blank' do
      contacts_params[0][:value] = ""
      contacts_params[1][:value] = ""
      params = {
        member_id: member.id,
        contacts: contacts_params
      }
      post :add_contacts, :params => params
      contacts = JSON.parse(response.body, {:symbolize_names => true})
      expect(contacts.size).to be(0)
    end
  end
  describe "unauthorised access" do
    it 'should not allow user to add contact' do
      post :add_contacts
      expect(response.status).to eq(401)
    end
  end
end
