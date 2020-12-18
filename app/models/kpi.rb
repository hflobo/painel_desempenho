class Kpi < ApplicationRecord
  belongs_to :indicator
  belongs_to :dashboard

  validates :nome, :ordem, :tipo_grafico, presence: true
  validates :nome, length: { maximum: 50 }

  def reordenar!
    self.dashboard.kpis.order("ordem asc, updated_at asc").each_with_index do |kpi, index|
      # byebug
      kpi.ordem = index + 1
      kpi.save
    end
  end
end
