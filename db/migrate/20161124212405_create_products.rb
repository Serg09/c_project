class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :book_id, null: false
      t.string :caption, limit: 256, null: false
      t.string :sku, limit: 40, null: false

      t.timestamps null: false
      t.index :sku, unique: true
      t.index [:book_id, :caption], unique: true
    end
  end
end
