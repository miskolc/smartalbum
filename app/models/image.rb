class Image < ActiveRecord::Base
  belongs_to :user
  mount_uploader :store, StoreUploader
  has_many :exif_fields
  has_many :faces
  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode, if: ->(obj){ obj.latitude.present? and obj.longitude.present? }
  self.per_page = 5
end
