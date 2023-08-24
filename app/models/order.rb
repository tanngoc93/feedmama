class Order < ApplicationRecord
  belongs_to :user

  after_create :destroy_abandoned_order

  private

  def destroy_abandoned_order
    DestroyAbandonedOrderJob.perform_at(24.hours.from_now, id)
  end
end
