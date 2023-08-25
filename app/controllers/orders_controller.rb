class OrdersController < ApplicationController
  def index
    @orders = current_user.orders.where(status: true).order(created_at: :desc)
  end

  def new
    @products = Product.where(status: true).order(price: :asc)
  end

  def create
    product = Product.where(status: true, id: order_params[:product_id]).first

    return redirect_to root_path,
      alert: "Oops, please try again later." unless product.present?

    price = Stripe::Price.retrieve(product.stripe_price_id)

    payment_link =
      Stripe::PaymentLink.create({
        line_items: [
          {
            price: price.id,
            quantity: order_params[:product_quantity] || 1,
          }, 
        ],
        after_completion: {
          type: 'redirect',
          redirect: {
            url: callback_url
          },
        },
      })

    order =
      current_user.orders.new(
        stripe_payment_link_id: payment_link.id,
        product_id: order_params[:product_id],
        product_quantity: order_params[:product_quantity] || 1,
        order_details: { payment_link: payment_link }.to_json
      )

    if order.save
      redirect_to payment_link.url, allow_other_host: true
    else
      render :new, alert: order&.errors&.full_messages&.to_sentence
    end
  rescue Stripe::CardError => e
    redirect_to new_charge_path, alert: e.message
  end

  private

  def order_params
    params.require(:order).permit(:product_id, :product_quantity)
  end

  def callback_url
    @callback_url ||= "#{ request.base_url }/stripe/callback".freeze
  end
end
