class AddColumnCommercial < ActiveRecord::Migration
  def change
    add_column :projects, :commercial, :boolean, default: false
  end
end
