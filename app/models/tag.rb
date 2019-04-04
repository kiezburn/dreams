class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :camps, through: :taggings
end
