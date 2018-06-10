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

RSpec.describe Member, type: :model do
  describe "validations" do
    it 'should should throw error when name is not present' do
      member = Member.create(:name => "", :age => 10, :place => Faker::Address.state)
      expect(member.valid?).to be_falsy
      expect(member.errors.messages).to eq({ :name=> ["can't be blank"] })
    end
    it 'should should throw error when age is not present' do
      member = Member.create(:name => Faker::Name.name, :age => "", :place => Faker::Address.state)
      expect(member.valid?).to be_falsy
      expect(member.errors.messages).to eq({ :age=> ["can't be blank"] })
    end

    it 'should should throw error when place is not present' do
      member = Member.create(:name => Faker::Name.name, :age => 10, :place => "")
      expect(member.valid?).to be_falsy
      expect(member.errors.messages).to eq({ :place=> ["can't be blank"] })
    end
  end
end
