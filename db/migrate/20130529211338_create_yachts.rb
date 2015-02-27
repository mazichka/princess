class CreateYachts < ActiveRecord::Migration

  def up
    create_table :yachts do |t|
      t.string  :name,           default: '',                null: false
      t.integer :year,           default: DateTime.now.year, null: false
      t.float   :length,         default: 0.0
      t.float   :width,          default: 0.0
      t.float   :weight,         default: 0.0
      t.float   :draft,          default: 0.0
      t.float   :fuel_tank,      default: 0.0
      t.float   :water_tank,     default: 0.0
      t.string  :engine,         default: ''
      t.integer :engines_number, default: 1
      t.float   :capacity,       default: 0
      t.float   :speed,          default: 0
      t.integer :hours,          default: 0
      t.string  :location,       default: ''
      t.string  :color,          default: ''
      t.integer :cabins,         default: 1
      t.integer :bunks,          default: 1
      t.text    :description,    default: ''
      t.boolean :customs,        default: false
      t.integer :price,          default: 0
      t.string  :currency,       default: 'EUR'

      t.text    :equipment,      default: ''
      t.text    :spare_parts,    default: ''
      t.text    :comments,       default: ''
      t.text    :options,        default: ''
      t.text    :interiors,      default: ''

      t.string  :status

      t.timestamps
    end

    add_index :yachts, :status
  end

  def down
    drop_table :yachts
  end

end
