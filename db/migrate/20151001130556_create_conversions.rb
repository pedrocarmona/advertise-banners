class CreateConversions < ActiveRecord::Migration
  def change
    create_table :conversions do |t|
      t.click :references
      t.string :revenue

      t.timestamps null: false
    end
  end
end
