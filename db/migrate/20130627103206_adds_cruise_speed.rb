class AddsCruiseSpeed < ActiveRecord::Migration

  def up
    add_column :yachts, :cruising_speed, :integer, default: 0, null: true
  end

  def down
    remove_column :yachts, :cruising_speed
  end

end
