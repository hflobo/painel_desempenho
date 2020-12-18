class Goal < ApplicationRecord
  belongs_to :indicator

  validates :indicator_id, :ano, :periodo, :valor, presence: true
  validates :periodo, uniqueness: { scope: [:ano, :indicator_id],
    message: "Período da meta deve ser único dentro de um ano para um indicador" }
  validates :periodo, numericality: { less_than_or_equal_to: ->(goal) { goal.indicator.qtd_metas_ano },
   message: "Um indicador não pode ter mais metas em um ano que o indicado em seu cadastro." }

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

