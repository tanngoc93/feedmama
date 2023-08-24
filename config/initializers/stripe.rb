Rails.configuration.stripe = {
  publishable_key: ENV.fetch("STRIPE_PUBLISHABLE_KEY") { SecureRandom.hex },
  secret_key: ENV.fetch("STRIPE_SECRET_KEY") { SecureRandom.hex }
}

Stripe.api_key = ENV.fetch("STRIPE_SECRET_KEY") { SecureRandom.hex }
