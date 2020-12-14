class Value < ApplicationRecord
  belongs_to :indicator

  validates :indicator_id, :ano, :periodo, :valor, presence: true
  validates :periodo, uniqueness: { scope: [:ano, :indicator_id],
    message: "Período deve ser único dentro de um ano para um indicador" }
  validates :periodo, numericality: { less_than_or_equal_to: ->(value) { value.indicator.qtd_apuracoes_ano },
    message: "Um indicador não pode ter mais valores em um ano que o indicado em seu cadastro." }
end
