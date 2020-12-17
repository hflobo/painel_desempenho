class Indicator < ApplicationRecord
  belongs_to :user
  belongs_to :objective
  belongs_to :region
  has_many :kpis, dependent: :destroy
  has_many :goals, dependent: :destroy
  has_many :values, dependent: :destroy
  has_many :alerts, dependent: :destroy
  has_many :dashboards, through: :kpi
  has_many :indicadores_filhos, class_name: 'Indicator', foreign_key: 'pai_indicator_id', dependent: :nullify

  validates :nome, :sigla, :qtd_apuracoes_ano, :qtd_metas_ano, presence: true
  # validates :nome, :sigla, uniqueness: { scope: :region_id,
  #            message: "Nome e sigla do indicador devem ser únicos para cada região." }
  validates :pai_indicator_id, exclusion: { in: ->(indicator) { [indicator.id.nil? ? '' : indicator.id] },
                                            message: "Um indicador não pode ser filho de si mesmo." } # , on: :update
  validates :qtd_apuracoes_ano, :qtd_metas_ano, numericality: { greater_than: 0, only_integer: true },
                                                inclusion: { in: [1, 2, 3, 4, 6, 12],
                                                             message: "%{value} deve ser um divisor de 12" }
  #
  #----------------------------------------------------------------------------
  # Função para obter um array de values ou goals de um indicador,
  # para um dado período
  #
  # Parâmetros da função:
  # 1) opcao: 0 - retorna um hash de values, 1 - retorna um hash de goals,
  #           2 - retorna um array com os dois hashes
  # 2) ano_inicio: integer / ano inicial da série
  # 3) ano_final: integer / ano final da série
  #----------------------------------------------------------------------------
  #
  def param_graph(opcao = 0, ano_inicio = Date.today.year, ano_final = Date.today.year)
    valorobj = {}
    metaobj = {}
    mes = ['jan', 'fev', 'mar', 'abr', 'mai', 'jun', 'jul', 'ago', 'set', 'out', 'nov', 'dez']
    xvalue = 12 / qtd_apuracoes_ano
    xgoal = 12 / qtd_metas_ano

    # Monta os Hash com os valores e metas mês a mês
    if [0, 2].include?(opcao)
      (ano_inicio..ano_final).to_a.each do |iano|
        valores = Value.where('ano = ? AND indicator_id = ?', iano, id)
        valores.each do |value|
          valorobj["#{mes[value.periodo * xvalue - 1]}/#{iano % 2000}"] = value.valor
        end
      end
    end
    if [1, 2].include?(opcao)
      (ano_inicio..ano_final).to_a.each do |iano|
        metas = Goal.where('ano = ? AND indicator_id = ?', iano, id)
        metas.each do |goal|
          metaobj["#{mes[goal.periodo * xgoal - 1]}/#{iano % 2000}"] = goal.valor
        end
      end
    end

    if opcao == 0
      return valorobj
    elsif opcao == 1
      return metaobj
    else
      metascheio = {}
      (ano_inicio..ano_final).to_a.each do |iano|
        case qtd_metas_ano
        when 1
          (1..11).to_a.each do |i|
            metascheio["#{mes[i - 1]}/#{iano % 2000}"] = metaobj["dez/#{iano % 2000}"]
          end
        when 2
          [1, 7].each do |i|
            (0..4).to_a.each do |j|
              metascheio["#{mes[i + j - 1]}/#{iano % 2000}"] = metaobj["#{mes[i + 4]}/#{iano % 2000}"]
            end
          end
        when 3
          [1, 5, 9].each do |i|
            (0..2).to_a.each do |j|
              metascheio["#{mes[i + j - 1]}/#{iano % 2000}"] = metaobj["#{mes[i + 2]}/#{iano % 2000}"]
            end
          end
        when 4
          [1, 4, 7, 10].each do |i|
            [0, 1].each do |j|
              metascheio["#{mes[i + j - 1]}/#{iano % 2000}"] = metaobj["#{mes[i + 1]}/#{iano % 2000}"]
            end
          end
        when 6
          [1, 3, 5, 7, 9, 11].each do |i|
            metascheio["#{mes[i - 1]}/#{iano % 2000}"] = metaobj["#{mes[i]}/#{iano % 2000}"]
          end
        end
      end

      valorobj.each do |valor|
        metaobj[valor[0]] = metascheio[valor[0]] if metaobj[valor[0]].nil?
      end
      return [{ name: "Indicador", data: valorobj }, { name: "Meta", data: metaobj }]
    end
  end

  #----------------------------------------------------------------------------
  #
  # Calcula o percentual de cumprimento da meta, no ano,
  # até o último valor alimentado e devolve um hash com:
  #
  # 1) O último valor alimentado;
  # 2) A meta associada a este valor;
  # 3) O percentual de cumprimento da meta, observado se max ou min;
  # 4) Percentual do ano ultrapassado até o mês do valor.
  #
  #----------------------------------------------------------------------------
  #
  def percent_meta
    metaobj = {}
    mes = ['jan', 'fev', 'mar', 'abr', 'mai', 'jun', 'jul', 'ago', 'set', 'out', 'nov', 'dez']
    iano = Date.today.year
    xvalue = 12 / qtd_apuracoes_ano
    xgoal = 12 / qtd_metas_ano

    metas = Goal.where('ano = ? AND indicator_id = ?', iano, id)
    metas.each do |goal|
      metaobj[mes[goal.periodo * xgoal - 1]] = goal.valor
    end

    case qtd_metas_ano
    when 1
      (1..11).to_a.each do |i|
        metaobj["#{mes[i - 1]}/#{iano % 2000}"] = metaobj["dez/#{iano % 2000}"]
      end
    when 2
      [1, 7].each do |i|
        (0..4).to_a.each do |j|
          metaobj["#{mes[i + j - 1]}/#{iano % 2000}"] = metaobj["#{mes[i + 4]}/#{iano % 2000}"]
        end
      end
    when 3
      [1, 5, 9].each do |i|
        (0..2).to_a.each do |j|
          metaobj["#{mes[i + j - 1]}/#{iano % 2000}"] = metaobj["#{mes[i + 2]}/#{iano % 2000}"]
        end
      end
    when 4
      [1, 4, 7, 10].each do |i|
        [0, 1].each do |j|
          metaobj["#{mes[i + j - 1]}/#{iano % 2000}"] = metaobj["#{mes[i + 1]}/#{iano % 2000}"]
        end
      end
    when 6
      [1, 3, 5, 7, 9, 11].each do |i|
        metaobj["#{mes[i - 1]}/#{iano % 2000}"] = metaobj["#{mes[i]}/#{iano % 2000}"]
      end
    end
    mesatual = Date.today.month
    mesperc = 0
    valorperc = 0
    valores = Value.where('ano = ? AND indicator_id = ?', iano, id)

    valores.each do |value|
      mesind = value.periodo * xvalue
      next unless mesind <= mesatual

      valorperc = value.valor
      mesperc = mesind
    end

    # Calcula o valor do cumprimento de acordo com o tipo da meta
    #
    metaperc = metaobj[mes[mesperc - 1]]
    if tipo_meta_max
      percent = (valorperc / metaperc * 100).round(2)
    else
      percent = ((2 - (valorperc / metaperc)) * 100).round(2)
    end
    percano = (((Date.today.month - 1) * 30 + Date.today.day) / 360.0 * 100).round(2)

    return { valor: valorperc, meta: metaperc, perc_meta: percent, perc_ano: percano }
  end
end
