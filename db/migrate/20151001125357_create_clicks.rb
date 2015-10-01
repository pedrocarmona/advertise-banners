class CreateClicks < ActiveRecord::Migration
  def change
    create_table :clicks do |t|
      t.banner :references

      t.timestamps null: false
    end
  end
end
