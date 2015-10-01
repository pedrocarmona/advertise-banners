class CreateBanners < ActiveRecord::Migration
  def change
    create_table :banners do |t|
      t.campaign :references

      t.timestamps null: false
    end
  end
end
