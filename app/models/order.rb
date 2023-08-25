class Order < ApplicationRecord
  belongs_to :product
  belongs_to :user

  after_create :destroy_abandoned_order
  after_update :update_tokens_for_user, if: -> { status }

  def amount
    @amount ||= product&.default_price&.fdiv(100)
  end

  def token_exchange
    @token_exchange ||= amount.present? ? amount * 1000 : 0
  end

  private

  def destroy_abandoned_order
    DestroyAbandonedOrderJob.perform_at(24.hours.from_now, id)
  end

  def update_tokens_for_user
    Token.find_or_initialize_by(user: user).increment!(:amount, token_exchange)
  end
end
