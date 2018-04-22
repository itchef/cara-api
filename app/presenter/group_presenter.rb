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

class GroupPresenter < Oprah::Presenter
    def json
        {
            id: id,
            name: name,
            description: description,
            members: Group.get_assigned_members_list(id)
        }
    end

    def group_assignment(group_member_map)
        {
            group: Oprah.present(Group.find(group_member_map.group_id)).json,
            member: Oprah.present(Member.find(group_member_map.member_id)).basic
        }
    end

    def full_data
        {
            name: name,
            description: description,
            members_count: GroupMemberMap.where(:group_id => id).count,
            members: Group.get_assigned_members_list_with_full_data(id)
                         .map { |member| Oprah.present(member).json }
        }
    end
end