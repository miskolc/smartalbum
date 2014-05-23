class AddLatitudeAndLongitudeToImage < ActiveRecord::Migration
  def change
    add_column :images, :latitude, :float
    add_column :images, :longitude, :float
  end
end
