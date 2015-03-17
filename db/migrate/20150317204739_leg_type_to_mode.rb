class LegTypeToMode < ActiveRecord::Migration
  def change
    rename_column :legs, :type, :mode
  end
end
