class RemoveAddressFromLocations < ActiveRecord::Migration
  def change
    remove_column :locations, :address, :string
  end
end
