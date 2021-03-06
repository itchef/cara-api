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

class MemberPresenter < Oprah::Presenter
    presents_many :contact_source_member_maps

    def json
        {
            id: id,
            name: name,
            age: age,
            place: place,
            photo_url: photo_url,
            contacts: ContactSourceMemberMap
                          .get_contact_list_for(id)
                          .as_json(:except => :id),
            phone_numbers: ContactSourceMemberMap
                       .get_phone_numbers(id)
                       .as_json(:except => :id)
        }
    end

    def basic
        {
            id: id,
            name: name,
            photo_url: photo_url
        }
    end
end