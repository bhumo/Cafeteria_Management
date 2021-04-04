class CreateMenuitems < ActiveRecord::Migration[6.1]
  def change
    create_table :menuitems do |t|
      t.integer :category_id
      t.decimal :price
      t.string :name
      t.text :description
      t.string :status
      t.timestamps
    end
  end
end
