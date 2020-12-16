class Indicator < ApplicationRecord
  belongs_to :user
  belongs_to :objective
  belongs_to :region
  # belongs_to :indicator
  has_many :kpis, dependent: :destroy
  # has_many :affiliateds, dependent: :destroy
  has_many :goals, dependent: :destroy
  has_many :values, dependent: :destroy
  has_many :alerts, dependent: :destroy
  # has_many :responsibles, dependent: :destroy
  has_many :dashboards, through: :kpi
  has_many :indicadores_filhos, class_name: 'Indicator', foreign_key: 'pai_indicator_id', dependent: :nullify

  validates :nome, :sigla, :finalidade, :qtd_apuracoes_ano, :qtd_metas_ano, presence: true
  validates :nome, :sigla, uniqueness: { scope: :region_id,
                                         message: "Nome e sigla do indicador devem ser únicos para cada região." }
  validates :pai_indicator_id, exclusion: { in: ->(indicator) { [indicator.id.nil? ? '' : indicator.id] },
                                            message: "Um indicador não pode ser filho de si mesmo." } # , on: :update
  validates :qtd_apuracoes_ano, :qtd_metas_ano, numericality: { greater_than: 0, only_integer: true }

  def percent_meta
    metaObj = {}
    mes = ['jan', 'fev', 'mar', 'abr', 'mai', 'jun', 'jul', 'ago', 'set', 'out', 'nov', 'dez']
    iano = Date.today.year
    xValue = 12 / qtd_apuracoes_ano
    xGoal = 12 / qtd_metas_ano

    metas = Goal.where('ano = ? AND indicator_id = ?', iano, id)
    metas.each do |goal|
      metaObj[mes[goal.periodo * xGoal - 1]] = goal.valor
    end

    case qtd_metas_ano
    when 1
      (1..11).to_a.each do |i|
        metaObj["#{mes[i - 1]}/#{iano % 2000}"] = metaObj["dez/#{iano % 2000}"]
      end
    when 2
      [1, 7].each do |i|
        (0..4).to_a.each do |j|
          metaObj["#{mes[i + j - 1]}/#{iano % 2000}"] = metaObj["#{mes[i + 4]}/#{iano % 2000}"]
        end
      end
    when 3
      [1, 5, 9].each do |i|
        (0..2).to_a.each do |j|
          metaObj["#{mes[i + j - 1]}/#{iano % 2000}"] = metaObj["#{mes[i + 2]}/#{iano % 2000}"]
        end
      end
    when 4
      [1, 4, 7, 10].each do |i|
        [0, 1].each do |j|
          metaObj["#{mes[i + j - 1]}/#{iano % 2000}"] = metaObj["#{mes[i + 1]}/#{iano % 2000}"]
        end
      end
    when 6
      [1, 3, 5, 7, 9, 11].each do |i|
        metaObj["#{mes[i - 1]}/#{iano % 2000}"] = metaObj["#{mes[i]}/#{iano % 2000}"]
      end
    end
    mesatual = Date.today.month
    mesPerc = 0
    valorPerc = 0
    valores = Value.where('ano = ? AND indicator_id = ?', iano, indicador.id)

    valores.each do |value|
      mesind = value.periodo * xValue

      next unless mesind <= mesatual

      valorPerc = value.valor
      mesPerc = mesind
    end

    # retorna o valor do cumprimento de acordo com o tipo da meta
    #
    if indicador.tipo_meta_max
      return (valorPerc / metaObj[mes[mesPerc - 1]] * 100).round(2)
    else
      return ((2 - (valorPerc / metaObj[mes[mesPerc - 1]])) * 100).round(2)
    end
  end
end
