class AddIsArchivedToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_archived, :boolean, :null => false, :default => false
    reversible do |direction|
      direction.up { User.update_all(:is_archived => false) }
      direction.down {
        remove_column :users, :is_archived
      }
    end
  end
end
