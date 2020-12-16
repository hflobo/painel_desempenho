class Dashboard < ApplicationRecord
  belongs_to :user
  has_many :kpis, dependent: :destroy

  validates :nome, presence: true
  validates :nome, uniqueness: { scope: :user_id, case_sensitive: false,
                                 message: "Usuário já possui um painel com este nome" }
end

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
# 2) opcao: 0 - retorna um hash de values, 1 - retorna um hash de goals,
#           2 - retorna um array com os dois hashes
# 3) ano_inicio: integer / ano inicial da série
# 4) ano_final: integer / ano final da série

def param_graph(indicador, opcao = 0, ano_inicio, ano_final)
  valorObj = {}
  metaObj = {}
  mes = ['jan', 'fev', 'mar', 'abr', 'mai', 'jun', 'jul', 'ago', 'set', 'out', 'nov', 'dez']
  xValue = 12 / indicador.qtd_apuracoes_ano
  xGoal = 12 / indicador.qtd_metas_ano

  # Monta os Hash com os valores e metas mês a mês
  if [0, 2].include?(opcao)
    (ano_inicio..ano_final).to_a.each do |iano|
      valores = Value.where('ano = ? AND indicator_id = ?', iano, indicador.id)
      valores.each do |value|
        valorObj["#{mes[value.periodo * xValue - 1]}/#{iano % 2000}"] = value.valor
      end
    end
  end
  if [1, 2].include?(opcao)
    (ano_inicio..ano_final).to_a.each do |iano|
      metas = Goal.where('ano = ? AND indicator_id = ?', iano, indicador.id)
      metas.each do |goal|
        metaObj["#{mes[goal.periodo * xGoal - 1]}/#{iano % 2000}"] = goal.valor
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
      case indicador.qtd_metas_ano
      when 1
        (1..11).to_a.each do |i|
          metasCheia["#{mes[i - 1]}/#{iano % 2000}"] = metaObj["dez/#{iano % 2000}"]
        end
      when 2
        [1, 7].each do |i|
          (0..4).to_a.each do |j|
            metasCheia["#{mes[i + j - 1]}/#{iano % 2000}"] = metaObj["#{mes[i + 4]}/#{iano % 2000}"]
          end
        end
      when 3
        [1, 5, 9].each do |i|
          (0..2).to_a.each do |j|
            metasCheia["#{mes[i + j - 1]}/#{iano % 2000}"] = metaObj["#{mes[i + 2]}/#{iano % 2000}"]
          end
        end
      when 4
        [1, 4, 7, 10].each do |i|
          [0, 1].each do |j|
            metasCheia["#{mes[i + j - 1]}/#{iano % 2000}"] = metaObj["#{mes[i + 1]}/#{iano % 2000}"]
          end
        end
      when 6
        [1, 3, 5, 7, 9, 11].each do |i|
          metasCheia["#{mes[i - 1]}/#{iano % 2000}"] = metaObj["#{mes[i]}/#{iano % 2000}"]
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
# até o último valor alimentado e devolve com duas casas decimais
#
def percent_meta(indicador)
  metaObj = {}
  mes = ['jan', 'fev', 'mar', 'abr', 'mai', 'jun', 'jul', 'ago', 'set', 'out', 'nov', 'dez']
  iano = Date.today.year
  xValue = 12 / indicador.qtd_apuracoes_ano
  xGoal = 12 / indicador.qtd_metas_ano

  metas = Goal.where('ano = ? AND indicator_id = ?', iano, indicador.id)
  metas.each do |goal|
    metaObj[mes[goal.periodo * xGoal - 1]] = goal.valor
  end

  case indicador.qtd_metas_ano
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
