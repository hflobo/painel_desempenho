# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Objetivos:
objectives = Objective.create([{ tipo: 'Estratégico', nome: 'Garantir a arrecadação necessária ao Estado',
                                 descricao: 'Aproximar a arrecadação efetiva da potencial' },
                               { tipo: 'Estratégico', nome: 'Aumentar a efetividade da cobrança',
                                 descricao: 'Tornar a cobrança mais efetiva' },
                               { tipo: 'Estratégico', nome: 'Reduzir litígios, com ênfase na prevenção',
                                 descricao: 'Reduzir a ocorrência de litigios administrativos' },
                               { tipo: 'de Processo', nome: 'Reduzir estoque de processos de cobrança no órgão preparador',
                                 descricao: 'Trabalhar o máximo de processos no preparo' },
                               { tipo: 'de Processo', nome: 'Reduzir estoque de processos de restituição',
                                 descricao: 'Trabalhar o máximo de processos de restituição' }])
puts objectives
regions = Region.create([{ nome: "1a Região Fiscal" }, { nome: "2a Região Fiscal" }, { nome: "3a Região Fiscal" },
                         { nome: "4a Região Fiscal" }, { nome: "5a Região Fiscal" }, { nome: "6a Região Fiscal" }, { nome: "7a Região Fiscal" }])
puts regions
users = User.create!([{ email: 'jvvelloso@gmail.com', password: '123456' }, { email: 'jvvelloso@rfb.gov.br', password: '123456' }])
puts users
puts Indicator.create!(nome: 'Realização da meta global de arrecadação', objective: objectives.first,
                       region: regions.first, unidade_de_medida: 'percentual', periodo_do_indice: 12, periodo_da_meta: 1,
                       user: users.first)
