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

  def param_graph(opcao = true, ano_inicio, ano_final)
    valorObj = {}
    metaObj = {}
    mes = ['jan', 'fev', 'mar', 'abr', 'mai', 'jun', 'jul', 'ago', 'set', 'out', 'nov', 'dez']
    xValue = 12 / self.qtd_apuracoes_ano
    xGoal = 12 / self.qtd_metas_ano

    # Monta os Hash com os valores e metas mês a mês
    if [0, 2].include?(opcao)
      (ano_inicio..ano_final).to_a.each do |iano|
        valores = Value.where('ano = ? AND indicator_id = ?', iano, self.id)
        valores.each do |value|
          valorObj["#{mes[value.periodo * xValue]}/#{iano % 2000}"] = value.valor
        end
      end
    end
    if [1, 2].include?(opcao)
      (ano_inicio..ano_final).to_a.each do |iano|
        metas = Goal.where('ano = ? AND indicator_id = ?', iano, self.id)
        metas.each do |goal|
          metaObj["#{mes[goal.periodo * xGoal]}/#{iano % 2000}"] = goal.valor
        end
      end
    end

    if opcao == 0
      return valorObj
    elsif opcao == 1
      return metaObj
    else
      metasCheia = {}
      (ano_inicio..ano_final).to_a.each do |iano|
        case self.qtd_metas_ano
        when 1
          (1..11).to_a.each do |i|
            metasCheia["#{mes[i]}/#{iano % 2000}"] = metaObj["dez/#{iano % 2000}"]
          end
        when 2
          [1, 7].each do |i|
            (0..4).to_a.each do |j|
              metasCheia["#{mes[i + j]}/#{iano % 2000}"] = metaObj["#{mes[i + 5]}/#{iano % 2000}"]
            end
          end
        when 3
          [1, 5, 9].each do |i|
            (0..2).to_a.each do |j|
              metasCheia["#{mes[i + j]}/#{iano % 2000}"] = metaObj["#{mes[i + 3]}/#{iano % 2000}"]
            end
          end
        when 4
          [1, 4, 7, 10].each do |i|
            [0, 1].each do |j|
              metasCheia["#{mes[i + j]}/#{iano % 2000}"] = metaObj["#{mes[i + 2]}/#{iano % 2000}"]
            end
          end
        when 6
          [1, 3, 5, 7, 9, 11].each do |i|
            metasCheia["#{mes[i]}/#{iano % 2000}"] = metaObj["#{mes[i + 1]}/#{iano % 2000}"]
          end
        end
      end

      valorObj.each do |valor|
        metaObj[valor[0]] = metasCheia[valor[0]] if metaObj[valor[0]].nil?
      end
      return [{ name: "Indicadores", data: valorObj }, { name: "Metas", data: metaObj }]
    end
  end

  # Calcula o percentual de cumprimento da meta, no ano,
  # até o último valor alimentado
  #
  def percent_meta
    metaObj = {}
    mes = ['jan', 'fev', 'mar', 'abr', 'mai', 'jun', 'jul', 'ago', 'set', 'out', 'nov', 'dez']
    iano = Date.today.year
    xValue = 12 / self.qtd_apuracoes_ano
    xGoal = 12 / self.qtd_metas_ano

    metas = Goal.where('ano = ? AND indicator_id = ?', iano, self.id)
    metas.each do |goal|
      metaObj[mes[goal.periodo * xGoal]] = goal.valor
    end

    case self.qtd_metas_ano
    when 1
      (1..11).to_a.each do |i|
        metaObj["#{mes[i]}/#{iano % 2000}"] = metaObj["dez/#{iano % 2000}"]
      end
    when 2
      [1, 7].each do |i|
        (0..4).to_a.each do |j|
          metaObj["#{mes[i + j]}/#{iano % 2000}"] = metaObj["#{mes[i + 5]}/#{iano % 2000}"]
        end
      end
    when 3
      [1, 5, 9].each do |i|
        (0..2).to_a.each do |j|
          metaObj["#{mes[i + j]}/#{iano % 2000}"] = metaObj["#{mes[i + 3]}/#{iano % 2000}"]
        end
      end
    when 4
      [1, 4, 7, 10].each do |i|
        [0, 1].each do |j|
          metaObj["#{mes[i + j]}/#{iano % 2000}"] = metaObj["#{mes[i + 2]}/#{iano % 2000}"]
        end
      end
    when 6
      [1, 3, 5, 7, 9, 11].each do |i|
        metaObj["#{mes[i]}/#{iano % 2000}"] = metaObj["#{mes[i + 1]}/#{iano % 2000}"]
      end
    end
    mesatual = Date.today.month
    valorperc = 0
    valores = Value.where('ano = ? AND indicator_id = ?', iano, self.id)
    valores.each do |value|
      mesind = value.periodo * xValue
      if mesind <= mesatual
        valorPerc = valeu.valor
        mesPerc = mesind
      end
    end
    return valorPerc / metaObj[mes[mesperc]] * 100
  end


end
