class CreateExifFields < ActiveRecord::Migration
  def change
    create_table :exif_fields do |t|
      t.integer :image_id
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end
