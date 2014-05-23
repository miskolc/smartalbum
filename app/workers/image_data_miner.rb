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

  def get_exif_data
    exif_data = @exif.to_hash
    exif_data.each do |key, value|
      @image.exif_fields.create key: key.to_s, value: value.to_s
      logger.info( key.to_s + " " + value.to_s )
    end
  end

  def perform(image_id)
    sleep 5
    @image = Image.find(image_id)
    url = 'public' + @image.store_url
  
    if is_jpeg_or_tiff? url 
      @exif = EXIFR::JPEG.new(url)
      if @exif.exif?
        get_image_location
        get_exif_data
      else 
        logger.info( "There is no EXIF data for file: " + url)
      end
    else
      logger.info( "The file: " + url + "\n is not a JPEG or TIFF file")
    end      

  end
end