class AddWaterToDream < ActiveRecord::Migration
  def change
    add_column :camps, :water, :string, :limit => 4096
  end
end
