class AddCategoryIdToImages < ActiveRecord::Migration
  def change
    add_column :images, :category_id, :integer
  end
end
