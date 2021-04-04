class CreateOrderitems < ActiveRecord::Migration[6.1]
  def change
    create_table :orderitems do |t|
      t.integer :order_id
      t.integer :quantity
      t.integer :menuitem_id

      t.timestamps
    end
  end
end
