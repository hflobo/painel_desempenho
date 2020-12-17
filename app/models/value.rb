class Value < ApplicationRecord
  belongs_to :indicator

  validates :indicator_id, :ano, :periodo, :valor, presence: true
  validates :periodo, uniqueness: { scope: %i[ano indicator_id],
                                    message: "Período deve ser único dentro de um ano para um indicador" }
  validates :periodo, numericality: { less_than_or_equal_to: ->(value) { value.indicator.qtd_apuracoes_ano },
                                      message: "Um indicador não pode ter mais valores em um ano que o indicado em seu cadastro." }

  def nome_periodo_valor
    mes = ['Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro']
    case indicator.qtd_apuracoes_ano
    when 1
      "Ano"
    when 2
      "#{periodo}º semestre"
    when 3
      "#{periodo}º quadrimestre"
    when 4
      "#{periodo}º trimestre"
    when 6
      "#{periodo}º bimestre"
    when 12
      (mes[periodo - 1]).to_s
    else
      "ERRO"
    end
  end
end
