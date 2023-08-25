class Product < ApplicationRecord
  has_many :orders

  before_create :create_stripe_product
  before_update :update_stripe_product
  before_destroy :destroy_stripe_product

  private

  def create_stripe_product
    stripe_product =
      Stripe::Product.create({
        name: self.name,
        active: self.status,
        default_price_data: {
          currency: 'usd',
          unit_amount: self.price * 100
        }
      })

    self.stripe_product_id = stripe_product.id
    self.stripe_price_id = stripe_product.default_price
    self.product_details = stripe_product.to_json
    self
  end

  def update_stripe_product
    product_attributes = {}

    if self.name_changed?
      product_attributes[:name] = self.name
    end

    if self.status_changed?
      product_attributes[:active] = self.status
    end

    if self.price_changed?
      stripe_price =
        Stripe::Price.create({
          currency: 'usd',
          unit_amount: self.price * 100,
          product: self.stripe_product_id
        })

      product_attributes[:default_price] = stripe_price.id

      stripe_product =
        Stripe::Product.update(self.stripe_product_id, product_attributes)

      Stripe::Price.update(self.stripe_price_id, { active: false })

      self.stripe_price_id = stripe_price.id
      self.product_details = stripe_product.to_json

    elsif !product_attributes.empty?
      stripe_product =
        Stripe::Product.update( self.stripe_product_id, product_attributes)

      self.product_details = stripe_product.to_json
    end

    self
  end

  def destroy_stripe_product
    Stripe::Product.delete(self.stripe_product_id)
  end
end
