class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :user_id
      t.string :store

      t.timestamps
    end
  end
end
