class StripesController < ApplicationController
  skip_before_action :authenticate_user!

  def webhook
    event = nil

    # Verify webhook signature and extract the event
    # See https://stripe.com/docs/webhooks#verify-events for more information.
    begin
      sig_header = request.env['HTTP_STRIPE_SIGNATURE']
      payload = request.body.read
      event = Stripe::Webhook.construct_event(payload, sig_header, ENV["STRIPE_WEBHOOK_SECRET"])
    rescue JSON::ParserError => e
      # Invalid payload
      return status 400
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      return status 400
    end

    if event['type'] == 'checkout.session.completed'
      # Retrieve the session. If you require line items in the response, you may include them by expanding line_items.
      session = Stripe::Checkout::Session.retrieve({
        id: event['data']['object']['id'],
        expand: ['line_items'],
      })

      line_items = session.line_items
      fulfill_order(line_items)
    end
  end

  def callback
    redirect_to root_path, notice: "Your payment is being processed."
  end

  private

  def fulfill_order(line_items)
    line_item = line_items.data.first

    order = Order.where(
      "JSON_EXTRACT(order_details, '$.price', '$.id') LIKE '%#{line_item.price.id}%'").first

    return unless order.present?

    order&.update(status: true)
  end
end
