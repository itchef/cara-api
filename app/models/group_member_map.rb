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

class GroupMemberMap < ApplicationRecord
    belongs_to :member
    belongs_to :group
    
    validate :unique_entry

    def self.get_all_assigned_members
        Member.all.where(
                      :id => self.select(:member_id).distinct
        )
    end

    private
    def unique_entry
        record = GroupMemberMap.find_by(:member_id => member_id, :group_id => group_id)
        if !record.nil?
            errors.add(:member_id, "Member is already assign to this group")
        end
    end
end
