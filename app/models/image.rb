class Image < ActiveRecord::Base
  belongs_to :user
  mount_uploader :store, StoreUploader
  has_many :exif_fields

  self.per_page = 5
end
