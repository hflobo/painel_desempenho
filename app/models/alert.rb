class Alert < ApplicationRecord
  belongs_to :indicator, :user
end
