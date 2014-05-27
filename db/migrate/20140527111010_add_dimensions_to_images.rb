class AddDimensionsToImages < ActiveRecord::Migration
  def change
    add_column :images, :original_width, :integer
    add_column :images, :original_height, :integer
    add_column :images, :normal_width, :integer
    add_column :images, :normal_height, :integer
  end
end
