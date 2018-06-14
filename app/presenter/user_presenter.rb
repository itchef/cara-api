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

class UserPresenter < Oprah::Presenter
  def json
    {
      id: id,
      first_name: first_name,
      last_name: last_name,
      username: login[:identification],
      unsubscribed: is_unsubscribed,
      admin: is_admin,
      archived: is_archived
    }
  end

  def recent
    {
      first_name: first_name,
      last_name: last_name,
      username: login[:identification],
      admin: is_admin,
      archived: is_archived
    }
  end
end