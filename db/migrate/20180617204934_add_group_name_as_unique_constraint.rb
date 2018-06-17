class AddGroupNameAsUniqueConstraint < ActiveRecord::Migration[5.2]
  def change
    add_index :groups, :name, unique: true
    change_column_null :groups, :name, false
  end
end
