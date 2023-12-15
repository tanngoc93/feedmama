class DestroyBlockerJob
  include Sidekiq::Job
  sidekiq_options retry: 3, dead: false

  def perform(id)
    Blocker.find_by(id: id)&.destroy
  end
end
