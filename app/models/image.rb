class Image < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  mount_uploader :store, StoreUploader
  has_many :exif_fields
  has_many :faces
  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode, if: ->(obj){ obj.latitude.present? and obj.longitude.present? }
  self.per_page = 5

  def self.search(name, category_id, sub_category_id)
    query = "1=1 "
    if name && name != ""
      query += "and store LIKE '%#{name}%' "
    end
    if category_id && category_id != ""
      query += "and category_id = '#{category_id}'"
    end
    if sub_category_id && sub_category_id != ""
      query += "and sub_category_id = '#{sub_category_id}'"
    end
      
    where(query)
  end
end
