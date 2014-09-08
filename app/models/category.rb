class Category < ActiveRecord::Base
  has_many :images
  has_many :sub_categories
  belongs_to :user
end
