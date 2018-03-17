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

class ContactSourceMemberMap < ApplicationRecord
    belongs_to :member
    belongs_to :contact_source

    def self.getContactListFor(member_id)
        ContactSourceMemberMap.select(
            [ContactSource.arel_table[:name], :value]
        ).where(
            ContactSourceMemberMap.arel_table[:member_id].eq(member_id).and(ContactSource.arel_table[:name].not_eq('phone'))
        ).joins(
            ContactSourceMemberMap.arel_table.join(ContactSource.arel_table).on(ContactSourceMemberMap.arel_table[:contact_source_id].eq(ContactSource.arel_table[:id])).join_sources
        )
    end

    def self.getPhoneNumbers(member_id)
        ContactSourceMemberMap.select(
            [ContactSource.arel_table[:name], :value]
        ).where(
            ContactSourceMemberMap.arel_table[:member_id].eq(member_id).and(ContactSource.arel_table[:name].eq('phone'))
        ).joins(
            ContactSourceMemberMap.arel_table.join(ContactSource.arel_table).on(ContactSourceMemberMap.arel_table[:contact_source_id].eq(ContactSource.arel_table[:id])).join_sources
        )
    end

end
