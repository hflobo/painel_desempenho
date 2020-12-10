class Responsible < ApplicationRecord
  belongs_to :indicator
  belongs_to :user
end
