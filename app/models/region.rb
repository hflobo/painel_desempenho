class Region < ApplicationRecord
  has_many :indicators

  validates :nome, presence: true
end
