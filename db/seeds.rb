# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

# puts 'Cleaning affiliateds...'
# Affiliated.destroy_all
puts 'Cleaning alerts...'
Alert.destroy_all
puts 'Cleaning goals...'
Goal.destroy_all
# puts 'Cleaning responsibles...'
# Responsible.destroy_all
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
             admin: true)

User.create!(email: 'joao.thiago@email.com',
             password: '123456',
             name: 'João Thiago',
             admin: true)
User.create!(email: 'joao.vicente@email.com',
             password: '123456',
             name: 'João Vicente',
             admin: true)

User.create!(email: 'marina@email.com',
             password: '123456',
             name: 'Marina',
             admin: true)

User.create!(email: 'orelha@email.com',
             name: 'Zé Orelha',
             password: '123456')

User.create!(email: 'outro_orelha@email.com',
             name: 'Mané Orelha',
             password: '123456')

puts 'Creating objectives...'
Objective.create!(nome: "Reduzir sonegação fiscal",
                  tipo: "Estratégico",
                  descricao: "Reduzir a sonegação fiscal em 5% a.a.")
Objective.create!(nome: "Aumentar arrecadação",
                  tipo: "Estratégico",
                  descricao: "Aumentar a arrecadação sem promover aumento de alíquotas.")

Objective.create!(nome: "Reduzir tempo de espera nas agências",
                  tipo: "Tático",
                  descricao: "Reduzir tempo de espera para atendimento nas agências")

Objective.create!(nome: "Melhorar imagem junto à sociedade",
                  tipo: "Estratégico",
                  descricao: "Trabalhar a imagem junto à sociedade para melhorar a percepção da RF")

Objective.create!(nome: "Reduzir gastos operacionais",
                  tipo: "Tático",
                  descricao: "Reduzir os gastos operacionais sem afetar negativamente a produtividade")

puts "Creating regions..."
Region.create!(nome: "Brasil")
Region.create!(nome: "Sul")
Region.create!(nome: "Sudeste")
Region.create!(nome: "Centro-Oeste")
Region.create!(nome: "Nordeste")
Region.create!(nome: "Norte")

puts "Creating indicators..."
usr1_id = User.first.id
Objective.all.each do |objective|
  indicator = Indicator.create!(nome: "Índice de #{objective.nome}",
                                sigla: "i#{objective.nome.split.map(&:first).join}",
                                finalidade: "indicar percentual de #{objective.nome}",
                                abrangencia: "nacional",
                                unidade_de_medida: :null,
                                qtd_apuracoes_ano: [2, 4, 12].sample,
                                qtd_metas_ano: rand(1..2),
                                user_id: usr1_id,
                                objective_id: objective.id,
                                region_id: Region.first.id)
  [0, 5].sample.times do |i|
    Indicator.create!(nome: "Índice de #{objective.nome}",
                      sigla: "i#{objective.nome.split.map(&:first).join}",
                      finalidade: "indicar percentual de #{objective.nome}",
                      abrangencia: "regional",
                      unidade_de_medida: "%",
                      qtd_apuracoes_ano: [2, 4, 12].sample,
                      qtd_metas_ano: rand(1..2),
                      user_id: usr1_id,
                      objective_id: objective.id,
                      region_id: (Region.first.id + i + 1),
                      pai_indicator_id: indicator.id)
  end
end

puts "Creating goals..."
Indicator.all.each do |indicator|
  (2017..2020).to_a.each do |ano|
    indicator.qtd_metas_ano.times do |i|
      Goal.create!(ano: ano,
                   periodo: i + 1,
                   valor: rand,
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
                    valor: rand,
                    indicator_id: indicator.id)
    end
  end
end

puts "creating dashboards..."
User.all.each do |user|
  Dashboard.create!(nome: "1º Painel de #{user.name}",
                    user_id: user.id)
  Dashboard.create!(nome: "2º Painel de #{user.name}",
                    user_id: user.id)
end

puts "creating kpis..."
Dashboard.all.each do |dashboard|
  indicadores = Indicator.all.sample(5)
  indicadores.each_with_index do |ind, i|
    Kpi.create!(dashboard_id: dashboard.id,
                indicator_id: ind.id,
                nome: ind.nome,
                destaque: :null,
                ordem: i + 1,
                tipo_grafico: "velocimetro")
  end
end

puts "creating alerts..."
User.where(admin: true).each do |user|
  rand(1..5).times do |_i|
    data = Faker::Date.backward(days: 60)
    Alert.create!(descricao: Faker::ChuckNorris.fact,
                  data_ciencia: data,
                  providencia: true,
                  texto_providencia: Faker::ChuckNorris.fact,
                  data_providencia: data + rand(0..60),
                  criador_id: user.id,
                  destinatario_id: User.all.sample.id,
                  indicator_id: Indicator.all.sample.id)
  end
end

puts "Ok. time to see the dashboards!"
