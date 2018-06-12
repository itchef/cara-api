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

Rails.application.routes.draw do
  # Custom Routes
  post '/access-token' => "session#create"
  post '/token', to: redirect('/', status: 404)

  post 'contacts/add_contacts', defaults: { format: :json }
  get 'members/names', defaults: { format: :json }

  post 'groups/assign_member', defaults: { format: :json }
  delete 'groups/:group_id/unassigned_member/:member_id' => "groups#unassigned_member", defaults: { format: :json }

  get 'users' => "users#index", defaults: { format: :json }
  post 'users' => "users#create", defaults: { format: :json }
  put 'users/:id/update_password' => "users#update_password", defaults: { format: :json }
  get 'users/:id/unsubscribe' => "users#unsubscribe", defaults: { format: :json }
  get 'users/:id/subscribe' => "users#subscribe", defaults: { format: :json }
  get 'users/recent' => "users#recent", defaults: { format: :json }

  resources :members, defaults: { format: :json }
  resources :groups, defaults: { format: :json }
  resources :dashboard, only: [:index], defaults: { format: :json }
end
