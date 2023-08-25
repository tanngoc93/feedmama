class Product < ApplicationRecord
  has_many :orders

  after_create :create_stripe_product
  after_destroy :destroy_stripe_product

  private

  def create_stripe_product
    stripe_product =
      Stripe::Product.create({
        name: self.name,
        active: self.status
      })

    self.update(stripe_product_id: stripe_product.id, product_details: stripe_product.to_json)
  end

  def destroy_stripe_product
    Stripe::Product.delete(self.stripe_product_id)
  end
end
