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

RSpec.describe User, type: :model do
  let(:subscibed_admin_user) {FactoryBot.create(:admin_subscribed_user)}
  let(:secondary_user) {FactoryBot.create(:secondary_user)}

  describe "find_by_username" do
    before(:each) do
    end

    after(:each) do
      User.delete_all
    end
    it 'should user by username' do
      user = User.find_by_username(subscibed_admin_user.login[:identification])
      expect(user[:first_name]).to eq(subscibed_admin_user[:first_name])
      expect(user[:last_name]).to eq(subscibed_admin_user[:last_name])
      expect(
        User.find_by_username("SOME_USER_NAME")
      ).to be_nil
    end
  end
end
