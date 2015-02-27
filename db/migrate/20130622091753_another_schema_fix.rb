class AnotherSchemaFix < ActiveRecord::Migration

  def change
    change_column :yachts, :year,        :integer, default: 2013,  null: true
    change_column :yachts, :length,      :float,   default: 0.0,   null: true
    change_column :yachts, :equipment,   :text,    default: '',    null: true
    change_column :yachts, :spare_parts, :text,    default: '',    null: true
    change_column :yachts, :comments,    :text,    default: '',    null: true
    change_column :yachts, :options,     :text,    default: '',    null: true
    change_column :yachts, :interiors,   :text,    default: '',    null: true
  end

end
