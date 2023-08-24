class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string  :name, null: false
      t.string  :stripe_product_id
      t.decimal :default_price, default: 0.0
      t.boolean :status
      t.json    :product_details

      t.timestamps
    end
  end
end
