class AddAdminColumnToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_admin, :boolean, :null => false, :default => false
    reversible do |direction|
      direction.up { User.update_all(:is_unsubscribed => false) }
      direction.down {
        remove_column :users, :is_admin
      }
    end
  end
end
