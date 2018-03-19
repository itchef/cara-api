class AddProfilePhotoForMembers < ActiveRecord::Migration[5.1]
    def change
        add_column :members, :photo_url, :string
    end
end
