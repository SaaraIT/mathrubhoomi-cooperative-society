class AddPositionToShgMembers < ActiveRecord::Migration[8.0]
  def change
    add_column :shg_members, :position, :integer
  end
end
