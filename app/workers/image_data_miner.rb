require 'exifr'
require 'ffi'

module Faces
  extend FFI::Library
  ffi_lib File.join(File.expand_path(File.join(File.dirname(__FILE__))), 'libfaces.so')
  attach_function :detect_faces, [:string, :string], :string
 
  def self.faces_in(image)
    keys = [:x,:y,:width,:height]

    detected_faces = detect_faces(image, nil)
    detected_faces.split("n").map do |e|
      vals = e.split(';').map(&:to_i)
      Hash[ keys.zip(vals) ]
    end
  end
end

class ImageDataMiner
  include Sidekiq::Worker
  sidekiq_options retry: false

  def get_extension url
    url.split('.')[-1].downcase
  end  

  def is_jpeg_or_tiff? url
    %w[jpg jpeg jpe jif jfif jfi tiff tif].include?(get_extension(url))
  end

  def get_human_faces
    human_faces = Faces.faces_in('/home/dragos/Programming/rails/spring-races/smartalbum/public'+@image.store_url(:normal))
    human_faces.each do |human_face|
      @image.faces.create!(x_coordinate: human_face[:x],
                           y_coordinate: human_face[:y],
                           width:        human_face[:width],
                           height:       20 )
    end 
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

    get_human_faces

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