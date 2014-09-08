class AddSubCategoryIdToImages < ActiveRecord::Migration
  def change
    add_column :images, :sub_category_id, :integer
  end
end
