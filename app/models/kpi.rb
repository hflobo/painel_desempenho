class Kpi < ApplicationRecord
  belongs_to :indicator
  belongs_to :dashboard
end
