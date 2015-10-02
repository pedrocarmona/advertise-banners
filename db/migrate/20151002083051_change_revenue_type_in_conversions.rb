class ChangeRevenueTypeInConversions < ActiveRecord::Migration
  def change
    change_column :conversions, :revenue, :float, :default => 0.0
  end
end
