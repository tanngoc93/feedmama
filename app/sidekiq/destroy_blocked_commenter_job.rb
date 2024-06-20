class DestroyBlockedCommenterJob
  include Sidekiq::Job
  sidekiq_options retry: 3, dead: false

  def perform(id)
    BlockedCommentator.find_by(id: id)&.destroy
  end
end
