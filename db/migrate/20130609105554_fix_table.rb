class FixTable < ActiveRecord::Migration

  class Yacht < ActiveRecord::Base; end

  def up
    rename_column :yachts, :engines_number, :engines_count
    add_column :yachts, :cabins_string, :string, null: false, default: '0'
    add_column :yachts, :bunks_string, :string, null: false, default: '0'

    FixTable::Yacht.find_each do |yacht|
      yacht.cabins_string = yacht.cabins
      yacht.bunks_string = yacht.bunks
    end

    remove_column :yachts, :cabins
    remove_column :yachts, :bunks

    rename_column :yachts, :cabins_string, :cabins
    rename_column :yachts, :bunks_string, :bunks

    change_column :yachts, :fuel_tank, :integer, null: false, default: 0
    change_column :yachts, :water_tank, :integer, null: false, default: 0
    change_column :yachts, :speed, :integer, null: false, default: 0
  end

  def down
    rename_column :yachts, :engines_count, :engines_number

    add_column :yachts, :cabins_integer, :integer, null: false, default: 0
    add_column :yachts, :bunks_integer, :integer, null: false, default: 0

    FixTable::Yacht.find_each do |yacht|
      yacht.cabins_integer = yacht.cabins.to_i
      yacht.bunks_integer = yacht.bunks.to_i
    end

    remove_column :yachts, :cabins
    remove_column :yachts, :bunks

    rename_column :yachts, :cabins_integer, :cabins
    rename_column :yachts, :bunks_integer, :bunks

    change_column :yachts, :fuel_tank, :float, null: false, default: 0
    change_column :yachts, :water_tank, :float, null: false, default: 0
    change_column :yachts, :speed, :integer, null: false, default: 0
  end

end
