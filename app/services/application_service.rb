class ApplicationService
  FB_VERSION = ENV.fetch("FB_VERSION") {"v16.0"}

  def self.call(*args, &block)
    new(*args, &block).call
  end
end