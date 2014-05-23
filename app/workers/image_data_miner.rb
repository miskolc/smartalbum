require 'exifr'

class ImageDataMiner
  include Sidekiq::Worker
  sidekiq_options retry: false

  def get_extension url
    url.split('.')[-1].downcase
  end  

  def is_jpeg_or_tiff? url
    %w[jpg jpeg jpe jif jfif jfi tiff tif].include?(get_extension(url))
  end

  def get_image_location
    if @exif.gps
      if @exif.gps.latitude
        @image.latitude = @exif.gps.latitude
      end
      if @exif.gps.longitude
        @image.longitude = @exif.gps.longitude 
      end
      @image.save
    end
  end

  def perform(image_id)
    sleep 5
    @image = Image.find(image_id)
    url = 'public' + @image.store_url
    # exposure_time = EXIFR::JPEG.new(url).exposure_time.to_s
    # width = EXIFR::JPEG.new(url).width.to_s
    if is_jpeg_or_tiff? url 
      @exif = EXIFR::JPEG.new(url)
      if @exif.exif?
        # Search location if any
        get_image_location

        # Get all exif data
        exif_data = @exif.to_hash
        exif_data.each do |key, value|
          @image.exif_fields.create key: key.to_s, value: value.to_s
          logger.info( key.to_s + " " + value.to_s )
        end
      else 
        logger.info( "There is no EXIF data for file: " + url)
      end
    else
      logger.info( "The file: " + url + "\n is not a JPEG or TIFF file")
    end      

  end
end