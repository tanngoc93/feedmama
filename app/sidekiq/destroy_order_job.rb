class DestroyOrderJob
  include Sidekiq::Job
  sidekiq_options retry: 3, dead: false

  def perform(id)
    Order.find_by(id: id, status: false)&.destroy
  end
end
