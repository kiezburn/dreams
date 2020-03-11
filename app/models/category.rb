class Category < ApplicationRecord
  NAMES = [
    'Art and Installation',
    'Performance',
    'Interactive Projects to Explore',
    'Workshop',
    'Communal Place',
    'None of the above (please have a dream guide contact me)'
  ]

  has_one :camp
  validates :name, presence: true
end
