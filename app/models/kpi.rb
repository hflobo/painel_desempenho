class Kpi < ApplicationRecord
  belongs_to :indicator
  belongs_to :dashboard

  validates :nome, :ordem, :tipo_grafico, presence: true
  validates :nome, length: { maximum: 50 }
  validates :ordem, numericality: { only_integer: true,
    less_than_or_equal_to: ->(kpi) {kpi.dashboard.kpis.length + (kpi.new_record? ? 1 : 0)} }
  # validates :ordem, numericality: { less_than_or_equal_to: 7 }

  def reordenar!(kpi_id, kpi_ordem_nova, kpi_ordem_velha )
    if kpi_ordem_nova < kpi_ordem_velha
      ordenacao = "ordem asc"
      condicao = "ordem BETWEEN #{kpi_ordem_nova} and #{kpi_ordem_velha}"
    else
      ordenacao = "ordem desc"
      condicao = "ordem BETWEEN #{kpi_ordem_velha} and #{kpi_ordem_nova}"
    end
    nova_ordem = kpi_ordem_nova + (kpi_ordem_nova < kpi_ordem_velha ? 1 : -1)
    self.dashboard.kpis.where(condicao).order(ordenacao).each do |kpi|
      # byebug
      if kpi.id != kpi_id
        kpi.ordem = nova_ordem
        kpi.save(validate: false)
        nova_ordem = nova_ordem + (kpi_ordem_nova < kpi_ordem_velha ? 1 : -1)
      end
    end
  end
end
