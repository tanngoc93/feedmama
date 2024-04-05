class Order < ApplicationRecord
  belongs_to :product
  belongs_to :user

  after_update :update_tokens_for_user, if: -> { status }

  def amount
    product.price * product_quantity
  end

  def token_exchange
    product.price * product_quantity * 1000
  end

  private

  def update_tokens_for_user
    Token.find_or_create_by(user: user)&.increment!(:amount, token_exchange)
  end
end
