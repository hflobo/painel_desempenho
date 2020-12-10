class Indicator < ApplicationRecord
  belongs_to :user
  belongs_to :objective
  belongs_to :region
  belongs_to :indicator
end
