class OrdersController < ApplicationController
  def new
    @products = Product.where(status: true)
                       .order(default_price: :asc).all
  end

  def create
    stripe_attributes = {}

    product = Product.where(status: true).first

    price =
      Stripe::Price.create({
        currency: 'usd',
        unit_amount: product.default_price,
        product: product.stripe_product_id,
      })

    stripe_attributes[:stripe_price] = price.to_json

    payment_link =
      Stripe::PaymentLink.create({
        line_items: [
          {
            price: price.id,
            quantity: 1,
          }, 
        ],
        after_completion: {
          type: 'redirect',
          redirect: {
            url: callback_url
          },
        },
      })

    stripe_attributes[:payment_link] = payment_link.to_json

    order =
      current_user.orders.new(
        order_parameters: {
          stripe_attributes: stripe_attributes
        }.to_json
      )

    if order.save
      redirect_to payment_link.url, allow_other_host: true
    else
      Stripe::Price.delete(price.id)
      Stripe::PaymentLink.delete(price.id)

      render :new, alert: order&.errors&.full_messages&.to_sentence
    end
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end

  def callback
    Rails.logger.debug ">>>>>>>>>>>>>>"
  end

  private

  def callback_url
    @callback_url ||= "#{ request.base_url }/orders/callback".freeze
  end
end
