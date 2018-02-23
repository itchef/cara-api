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
Rails.application.configure do
    config.cache_classes = false

    config.eager_load = false

    config.consider_all_requests_local = true

    if Rails.root.join('tmp/caching-dev.txt').exist?
        config.action_controller.perform_caching = true

        config.cache_store = :memory_store
        config.public_file_server.headers = {
            'Cache-Control' => "public, max-age=#{2.days.seconds.to_i}"
        }
    else
        config.action_controller.perform_caching = false

        config.cache_store = :null_store
    end

    # Don't care if the mailer can't send.
    config.action_mailer.raise_delivery_errors = false

    config.action_mailer.perform_caching = false

    # Print deprecation notices to the Rails logger.
    config.active_support.deprecation = :log

    # Raise an error on page load if there are pending migrations.
    config.active_record.migration_error = :page_load


    # Raises error for missing translations
    # config.action_view.raise_on_missing_translations = true

    # Use an evented file watcher to asynchronously detect changes in source code,
    # routes, locales, etc. This feature depends on the listen gem.
    config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
