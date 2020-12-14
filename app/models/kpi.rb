class Kpi < ApplicationRecord
  belongs_to :indicator
  belongs_to :dashboard

  validates :ordem, :tipo_grafico, presence: true
end
