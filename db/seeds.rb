# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

puts 'Cleaning alerts...'
Alert.destroy_all
puts 'Cleaning goals...'
Goal.destroy_all
puts 'Cleaning values...'
Value.destroy_all
puts 'Cleaning kpis...'
Kpi.destroy_all
puts 'Cleaning dashboars...'
Dashboard.destroy_all
puts 'Cleaning indicators...'
Indicator.destroy_all
puts 'Cleaning regions...'
Region.destroy_all
puts 'Cleaning objetives...'
Objective.destroy_all
puts 'Cleaning users...'
User.destroy_all

puts 'creating users...'
User.create!(email: 'hflobo@gmail.com',
             password: '123456',
             name: 'Hugo',
             admin: true,
             gestor: true)

User.create!(email: 'joao.thiago@email.com',
             password: '123456',
             name: 'João Thiago',
             admin: true,
             gestor: true)

User.create!(email: 'joao.vicente@email.com',
             password: '123456',
             name: 'João Vicente',
             admin: true,
             gestor: true)

User.create!(email: 'marina@email.com',
             password: '123456',
             name: 'Marina',
             admin: true,
             gestor: true)

User.create!(email: 'orelha@email.com',
             name: 'Zé Orelha',
             password: '123456',
             admin: false,
             gestor: false)

User.create!(email: 'outro_orelha@email.com',
             name: 'Mané Orelha',
             password: '123456',
             admin: false,
             gestor: false)

puts 'Creating objectives...'
Objective.create!(nome: "Aproximar a arrecadação efetiva da potencial",
                  tipo: "Estratégico",
                  descricao: "Garantir que o valor arrecadado se aproxime, ao máximo, do potencial arrecadatório")
Objective.create!(nome: "Aumentar a satisfação dos contribuintes com a Receita Federal",
                  tipo: "Estratégico",
                  descricao: "Entregar serviços de qualidade ao cidadão, tornando mais fácil para eles cumprir suas obrigações tributárias")

Objective.create!(nome: "Intensificar a oferta de serviços por meio digital",
                  tipo: "de Processo",
                  descricao: "Atender a todos os brasileiros, oferecendo serviços de melhor qualidade, mais simples e acessíveis")

Objective.create!(nome: "Agilizar a análise de demandas requeridas à Receita Federal",
                  tipo: "de Processo",
                  descricao: "Tempestividade no tempo de resposta às demandas, eficiência e efetividade")

Objective.create!(nome: "Otimizar o desenvolvimento do corpo funcional",
                  tipo: "de Pessoas e Recursos",
                  descricao: "Desenvolver o corpo funcional para aprimorar suas competências para lidar com as demandas do mundo contemporãneo")

puts "Creating regions..."
Region.create!(nome: "1ª Região Fiscal")
Region.create!(nome: "2ª Região Fiscal")
Region.create!(nome: "3ª Região Fiscal")
Region.create!(nome: "4ª Região Fiscal")
Region.create!(nome: "5ª Região Fiscal")
Region.create!(nome: "6ª Região Fiscal")
Region.create!(nome: "7ª Região Fiscal")
Region.create!(nome: "8ª Região Fiscal")
Region.create!(nome: "9ª Região Fiscal")
Region.create!(nome: "10ª Região Fiscal")

puts "Creating indicators..."
usr1_id = User.first.id

Objective.all.each do |objective|
  case objective.nome
  when "Aproximar a arrecadação efetiva da potencial"
    nome = 'Índice de realização da meta global de arrecadação bruta'
  when "Aumentar a satisfação dos contribuintes com a Receita Federal"
    nome = "Indíce de satisfação dos contribuintes com a Receita Federal"
  when "Intensificar a oferta de serviços por meio digital"
    nome = "Índice de novos serviços disponibilizados em plataformas virtuais"
  when "Agilizar a análise de demandas requeridas à Receita Federal"
    nome = "Idade média dos pedidos de restituição, ressarcimento e reembolso"
  when "Otimizar o desenvolvimento do corpo funcional"
    nome = "Índice de amplitude de capacitação e desenvolvimento"
  end

  puts "Nome: " + nome

  tipo_meta_max = %i[true true true false].sample
  indicator = Indicator.create!(nome: nome,
                                sigla: "ID#{objective.nome.split.map(&:first).join.first(2)}",
                                abrangencia: "Nacional",
                                unidade_de_medida: ['unidade', 'percentual', 'percentual', 'percentual'].sample,
                                qtd_apuracoes_ano: [2, 4, 12].sample,
                                qtd_metas_ano: [1, 4].sample,
                                user_id: usr1_id,
                                objective_id: objective.id,
                                region_id: Region.first.id,
                                pai_indicator_id: nil,
                                tipo_meta_max: tipo_meta_max)

  next unless :true == %i[true false].sample

  5.times do |i|
    Indicator.create!(nome: nome,
                      sigla: "ID#{objective.nome.split.map(&:first).join.first(2)}",
                      abrangencia: "Regional",
                      unidade_de_medida: indicator.unidade_de_medida,
                      valor_maximo: [1, 100, 1000].sample,
                      qtd_apuracoes_ano: [2, 4, 12].sample,
                      qtd_metas_ano: rand(1..2),
                      user_id: usr1_id,
                      objective_id: objective.id,
                      region_id: (Region.first.id + i + 1),
                      pai_indicator_id: indicator.id,
                      tipo_meta_max: tipo_meta_max)
  end
end

puts "Creating goals..."
Indicator.all.each do |indicator|
  (2017..2020).to_a.each do |ano|
    val = rand(3.5..6.00)
    puts val
    indicator.qtd_metas_ano.times do |i|
      Goal.create!(ano: ano,
                   periodo: i + 1,
                   valor: rand * indicator.valor_maximo,
                   indicator_id: indicator.id)
    end
  end
end

puts "Creating values..."
Indicator.all.each do |indicator|
  (2017..2020).to_a.each do |ano|
    indicator.qtd_apuracoes_ano.times do |i|
      Value.create!(ano: ano,
                    periodo: i + 1,
                    valor: rand * indicator.valor_maximo,
                    indicator_id: indicator.id)
    end
  end
end

puts "creating dashboards..."
User.all.each do |user|
  Dashboard.create!(nome: "Arrecadação",
                    user_id: user.id)
  Dashboard.create!(nome: "Fiscalização",
                    user_id: user.id)
  Dashboard.create!(nome: "Atendimento",
                    user_id: user.id)
end

puts "creating kpis..."
Dashboard.all.each do |dashboard|
  indicadores = Indicator.all.sample(5)
  indicadores.each_with_index do |ind, i|
    tipo = ["circular", "circular", "circular", "circular", "linha", "barra"].sample
    Kpi.create!(dashboard_id: dashboard.id,
                indicator_id: ind.id,
                nome: ind.nome[0..49],
                destaque: tipo != "circular",
                ordem: i + 1,
                tipo_grafico: tipo)
  end
end

puts "creating alerts..."
User.where(admin: true).each do |user|
  rand(1..5).times do |_i|
    data = Faker::Date.backward(days: 60)
    Alert.create!(descricao: Faker::ChuckNorris.fact,
                  data_ciencia: data,
                  providencia: true,
                  arquivado: false,
                  texto_providencia: Faker::ChuckNorris.fact,
                  data_providencia: data + rand(0..60),
                  criador_id: user.id,
                  destinatario_id: User.where("id <> #{user.id}").sample.id,
                  indicator_id: Indicator.all.sample.id)
  end
end

puts "Ok. time to see the dashboards!"
