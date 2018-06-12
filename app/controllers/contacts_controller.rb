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

class ContactsController < ApplicationController
  include RailsApiAuth::Authentication
  include AbilityHelper
  before_action :authenticate!

  def add_contacts
    can_manage?
    contacts = contacts_params
    contacts.each do | contact |
      contact_source = ContactSource.find_by(:name => contact[:name])
      member = Member.find(get_member_id_from_params)
      contact_source_member_map = ContactSourceMemberMap.find_or_initialize_by(:member => member,
                                                                               :contact_source => contact_source)
      if (not contact_source_member_map.new_record?) and not (contact[:value].blank?)
        contact_source_member_map.update(:value => contact[:value])
      elsif not contact[:value].blank?
        contact_source_member_map[:value] = contact[:value]
        contact_source_member_map.save
      elsif contact[:value].blank?
        contact_source_member_map.destroy unless contact_source_member_map.new_record?
      else
        render json: {message: 'Request Error. Please check the information.', detailed_message: contact_source_member_map.errors.messages }, :status => :bad_request
        return
      end
    end
    render json: ContactSourceMemberMap
                   .get_all_contact_list_for(get_member_id_from_params)
                   .as_json(:except => :id)
  end

  private
  def get_member_id_from_params
    params.permit(:member_id)[:member_id]
  end

  def contacts_params
    params.require(:contacts)
  end
end
