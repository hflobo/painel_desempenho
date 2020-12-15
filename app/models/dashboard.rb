class Dashboard < ApplicationRecord
  belongs_to :user
  has_many :kpis, dependent: :destroy

  validates :nome, presence: true
  validates :nome, uniqueness: { scope: :user_id, case_sensitive: false,
                                 message: "Usuário já possui um painel com este nome" }

  # Função para obter um array de values ou goals de um indicador,
  # para um dado período
  #
  # Exemplos de chamadas do chartkick para renderização de gráficos:
  #
  # 1. Linha:
  # 2. Colunas:
  # 3. Área:
  # 4. Rosca:
  #
  # Parâmetros da função:
  # 1) indicador: instância de indicator;
  # 2) opcao: true - retorna values, false - retorna goals
  # 3) ano_inicio: integer / ano inicial da série
  # 4) ano_final: integer / ano final da série
  # 5) mes_inicio: integer / mês inicial da série
  # 4) ano_final: integer / mês final da série
  # 5) percent: devolve o percentual de cumprimento da meta até hoje

  #  def param_graphics(indicador, opcao = true, ano_inicio, ano_final, mes_inicio, mes_final, percent)
  #
  #    valObj = Hash.new
  #    if opcao
  #      (ano_inicio..ano_final).to_a.each do |ano|
  #
  #     end
  #     'criador_id = ? AND arquivado = ?'current_user.id, false
end
