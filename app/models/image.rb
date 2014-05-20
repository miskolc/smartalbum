class Image < ActiveRecord::Base
  belongs_to :user
  mount_uploader :store, StoreUploader
end
