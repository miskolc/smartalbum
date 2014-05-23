class AddAddressToImage < ActiveRecord::Migration
  def change
    add_column :images, :address, :string
  end
end
