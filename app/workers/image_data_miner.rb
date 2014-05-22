class ImageDataMiner
  include Sidekiq::Worker

  def perform(name, count)
    logger.info 'Doing hard work'
  end
end