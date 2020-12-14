class Goal < ApplicationRecord
  belongs_to :indicator

  validates :indicator_id, :ano, :periodo, :valor, presence: true
  validates :periodo, uniqueness: { scope: [:ano, :indicator_id],
    message: "Período da meta deve ser único dentro de um ano para um indicador" }
  validates :periodo, numericality: { less_than_or_equal_to: ->(goal) { goal.indicator.qtd_metas_ano },
   message: "Um indicador não pode ter mais metas em um ano que o indicado em seu cadastro." }
end
