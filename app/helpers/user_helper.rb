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

module UserHelper
    def is_sign_up_params_present?(params)
        return false if
            params[:identification].empty? || params[:password].empty? || params[:password_confirmation].empty?
        true
    end

    def is_password_params_present?(params)
        return false if
            params[:password].empty? || params[:password_confirmation].empty?
        true
    end

    def passwords_matched?(params)
        return true if
            params[:password] === params[:password_confirmation]
        false
    end
end
