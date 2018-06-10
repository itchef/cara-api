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

# Specs in this file have access to a helper object that includes
# the UserHelper. For example:
#
# describe UserHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe UserHelper, type: :helper do
  describe "is_sign_up_params_present" do
    it 'should returns true when params contains all signup values' do
      params = {
        identification: Faker::Internet.email,
        password: Faker::Internet.password,
        password_confirmation: Faker::Internet.password
      }
      expect(helper.is_sign_up_params_present? params).to be_truthy
    end

    it 'should be falsy when identifier is not present on signup values' do
      params = {
        identification: "",
        password: Faker::Internet.password,
        password_confirmation: Faker::Internet.password
      }
      expect(helper.is_sign_up_params_present? params).to be_falsy
    end

    it 'should be falsy when password is not present on signup values' do
      params = {
        identification: Faker::Internet.email,
        password: "",
        password_confirmation: Faker::Internet.password
      }
      expect(helper.is_sign_up_params_present? params).to be_falsy
    end

    it 'should be falsy when password confirmation is not present on signup values' do
      params = {
        identification: Faker::Internet.email,
        password: Faker::Internet.password,
        password_confirmation: ""
      }
      expect(helper.is_sign_up_params_present? params).to be_falsy
    end
  end
  describe "is_password_params_present" do
    it 'should returns true when params contains all password change values' do
      params = {
        password: Faker::Internet.password,
        password_confirmation: Faker::Internet.password
      }
      expect(helper.is_password_params_present? params).to be_truthy
    end

    it 'should be falsy when password is not present on password change values' do
      params = {
        password: "",
        password_confirmation: Faker::Internet.password
      }
      expect(helper.is_password_params_present? params).to be_falsy
    end

    it 'should be falsy when password confirmation is not present on password change values' do
      params = {
        password: Faker::Internet.password,
        password_confirmation: ""
      }
      expect(helper.is_password_params_present? params).to be_falsy
    end
  end
  describe "passwords_matched?" do
    it 'should be truthy when password matches' do
      password = Faker::Internet.password
      params = {
        password: password,
        password_confirmation: password
      }
      expect(helper.passwords_matched? params).to be_truthy
    end
    it 'should falsy when one of the params values are not equal' do
      params = {
        password: Faker::Internet.password,
        password_confirmation: Faker::Internet.password
      }
      expect(helper.passwords_matched? params).to be_falsy
    end
  end
end
