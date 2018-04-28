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

class UsersController < ApplicationController
    include UserHelper

    def index
        render json: User.all.map { |user| Oprah.present(user).json }
    end

    def create
        user = User.new(user_params)
        if user.valid? && is_sign_up_params_present?(login_params)
            user.save && user.create_login(login_params)
            render json: Oprah.present(user).json
        else
            render json:
                       { message: 'Mandatory Fields are empty' },
                   :status => :unprocessable_entity
        end
    end

    private
    def user_params
        params.permit(:first_name, :last_name)
    end

    def login_params
        sign_up_params = params.permit(:password, :password_confirmation)
        sign_up_params[:identification] = params[:username]
        sign_up_params
    end
end
