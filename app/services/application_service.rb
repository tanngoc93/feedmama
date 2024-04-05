class ApplicationService
  FACEBOOK_VERSION = ENV.fetch('FACEBOOK_VERSION') {'v16.0'}

  def self.call(*args, &block)
    new(*args, &block).call
  end

  def headers
    {
      'Content-Type': 'application/json'
    }
  end
end