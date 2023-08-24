class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.integer    :city_id
      t.string     :zip_code
      t.string     :delivery_address
      t.boolean    :status, default: false
      t.json       :order_details
      t.references :user, foreign_key: true
      t.references :product, foreign_key: true

      t.timestamps
    end
  end
end
