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

class GroupsController < ApplicationController
  include RailsApiAuth::Authentication
  include AbilityHelper
  before_action :authenticate!
  before_action :set_group, only: [:destroy]

  def index
    render json: Group.all.map {|group| Oprah.present(group).json }
  end

  def create
    can_manage?
    group = Group.new(group_params)
    if group.valid?
      group.save
      render json: Oprah.present(group).json
    else
      render json: {message: 'Request Error. Group name / description can not be blank', detailed_message: group.errors.messages}, :status => :bad_request
    end
  end

  def assign_member
    can_manage?
    group_member_map = GroupMemberMap.new(group_member_map_params)
    if group_member_map.valid?
      group_member_map.save
      render json: Oprah.present(Group.find(group_member_map.group_id)).group_assignment(group_member_map)
    else
      render json: {message: 'Member is already assigned to group', detailed_message: group_member_map.errors.messages}, :status => :bad_request
    end
  end

  def unassigned_member
    can_manage?
    group_member_map = GroupMemberMap.find_by(group_member_map_params)
    if not group_member_map.nil? and group_member_map.delete
      render json: Oprah.present(Member.find(group_member_map[:member_id])).basic
    else
      render json: {message: 'Member is unable to unassigned'}, :status => :bad_request
    end
  end

  def destroy
    can_manage?
    if @group.destroy
      render json: @group, status: :ok
    else
      render json: {message: 'Group is unable to get deleted.', detailed_message: @group.errors.messages },
             :status =>
               :bad_request
    end
  end

  private
  def group_params
    params.require(:group).permit(:name, :description)
  end

  def group_member_map_params
    params.permit(:group_id, :member_id)
  end

  def set_group
    @group = Group.find(params[:id])
  end

end
