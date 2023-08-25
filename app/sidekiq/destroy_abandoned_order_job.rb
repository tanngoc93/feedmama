class DestroyAbandonedOrderJob
  include Sidekiq::Job
  sidekiq_options queue: :abandoned_order_check, retry: 3, dead: false

  def perform(id)
    Order.find_by(id: id, status: false)&.destroy
  end
end
