require 'exifr'

class ImageDataMiner
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(image, count)
    sleep 10
    exposure_time = EXIFR::JPEG.new(image).exposure_time.to_s
    width = EXIFR::JPEG.new(image).width.to_s
    logger.info('Doing hard work?' + exposure_time + ' ' + width)
  end
end