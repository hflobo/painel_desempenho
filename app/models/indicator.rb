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
end
