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

class MembersController < ApplicationController
    before_action :set_member, only: [:show]

    def index
        @members = Member.all.map {|member| Oprah.present(member).json }
        render json: @members
    end

    def names
        render json: Member.all.select(:id, :name)
    end

    def show
        render json: Oprah.present(@member).json
    end

    def create
        member = Member.new(member_params)
        if member.valid?
            member.save
            render json: member
        else
            render json: {message: 'Request Error. Member name / age / place can not be null.', detailed_message: member.errors.messages }, :status => :bad_request
        end
    end

    private
    def set_member
        @member = Member.find(params[:id])
    end

    def member_params
        params.require(:personal).permit(:name, :age, :place, :photo_url)
    end
end
