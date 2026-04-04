class ChangeHypothecationDeedDateFieldsToStrings < ActiveRecord::Migration[8.0]
  def up
    change_column :hypothecation_deeds, :day, :string
    change_column :hypothecation_deeds, :month, :string
    change_column :hypothecation_deeds, :year, :string
  end

  def down
    change_column :hypothecation_deeds, :day, :integer
    change_column :hypothecation_deeds, :month, :integer
    change_column :hypothecation_deeds, :year, :integer
  end
end
