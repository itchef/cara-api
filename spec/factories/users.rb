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

FactoryBot.define do
  factory :admin_subscribed_user, class: User do
    first_name         Faker::Name.first_name
    last_name          Faker::Name.last_name
    is_unsubscribed    false
    is_admin            true
    association :login, factory: :subscribed_login
  end

  factory :secondary_user, class: User do
    first_name         Faker::Name.first_name
    last_name          Faker::Name.last_name
    is_unsubscribed    false
    is_admin           false
    association :login, factory: :secondary_user_login
  end

  factory :secondary_unsubscribed_user, class: User do
    first_name         Faker::Name.first_name
    last_name          Faker::Name.last_name
    is_unsubscribed    true
    association :login, factory: :secondary_unsubscribed_user_login
  end
end
