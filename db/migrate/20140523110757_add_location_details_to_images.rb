class AddLocationDetailsToImages < ActiveRecord::Migration
  def change
    add_column :images, :latitude, :integer
    add_column :images, :longitude, :integer
    add_column :images, :address, :string
  end
end
