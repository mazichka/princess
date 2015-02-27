class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :type
      t.string :attachment

      t.integer :yacht_id

      t.timestamps
    end

    add_index :photos, :type
  end
end
