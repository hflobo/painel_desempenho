class Alert < ApplicationRecord
  belongs_to :indicator
  belongs_to :user
end
