class Category < ApplicationRecord
  NAMES = [
    'Art installation',
    'Performance / Workshop',
    'Workshop space / Workshop place',
    'None of the above (please have a dream guide contact me)']

  has_one :camp
  validates :name, presence: true
end
