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
    def index
        render json: Group.all.map {|group| Oprah.present(group).json }
    end

    def create
        group = Group.new(group_params)
        if group.valid?
            group.save
            render json: Oprah.present(group).json
        else
            render json: {message: 'Request Error. Group name / description can not be blank', detailed_message: group.errors.messages}, :status => :bad_request
        end
    end
    
    private
    def group_params
        params.require(:group).permit(:name, :description)
    end

end
