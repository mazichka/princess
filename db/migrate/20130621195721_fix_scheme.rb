class FixScheme < ActiveRecord::Migration

  def change
    change_column :yachts, :name,          :string,  default: '',    null: false
    change_column :yachts, :year,          :integer, default: 2013,  null: false
    change_column :yachts, :length,        :float,   default: 0.0,   null: false
    change_column :yachts, :width,         :float,   default: 0.0,   null: true
    change_column :yachts, :weight,        :float,   default: 0.0,   null: true
    change_column :yachts, :draft,         :float,   default: 0.0,   null: true
    change_column :yachts, :fuel_tank,     :integer, default: 0,     null: true
    change_column :yachts, :water_tank,    :integer, default: 0,     null: true
    change_column :yachts, :engine,        :string,  default: '',    null: true
    change_column :yachts, :engines_count, :integer, default: 0,     null: true
    change_column :yachts, :capacity,      :float,   default: 0.0,   null: true
    change_column :yachts, :speed,         :integer, default: 0,     null: true
    change_column :yachts, :hours,         :integer, default: 0,     null: true
    change_column :yachts, :location,      :string,  default: '',    null: true
    change_column :yachts, :color,         :string,  default: '',    null: true
    change_column :yachts, :cabins,        :string,  default: '',    null: true
    change_column :yachts, :bunks,         :string,  default: '',    null: true
    change_column :yachts, :customs,       :boolean,                 null: true
    change_column :yachts, :description,   :text,    default: '',    null: false
    change_column :yachts, :currency,      :string,  default: 'EUR', null: false
    change_column :yachts, :equipment,     :text,    default: '',    null: false
    change_column :yachts, :spare_parts,   :text,    default: '',    null: false
    change_column :yachts, :comments,      :text,    default: '',    null: false
    change_column :yachts, :options,       :text,    default: '',    null: false
    change_column :yachts, :interiors,     :text,    default: '',    null: false
    change_column :yachts, :price,         :integer, default: 0,     null: false
  end

end
