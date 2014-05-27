class CreateFaces < ActiveRecord::Migration
  def change
    create_table :faces do |t|
      t.integer :image_id
      t.integer :x_coordinate
      t.integer :y_coordinate
      t.integer :height
      t.integer :width

      t.timestamps
    end
  end
end
