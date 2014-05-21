class Image < ActiveRecord::Base
  belongs_to :user
  mount_uploader :store, StoreUploader

  self.per_page = 5
end
