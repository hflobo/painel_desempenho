class Indicator < ApplicationRecord
  belongs_to :user
  belongs_to :objective
  belongs_to :region
  # belongs_to :indicator
  has_many :kpis, dependent: :destroy
  has_many :affiliateds, dependent: :destroy
  has_many :goals, dependent: :destroy
  has_many :values, dependent: :destroy
  has_many :alerts, dependent: :destroy
  has_many :responsibles, dependent: :destroy
  has_many :dashboards, through: :kpi
  has_many :indicadores_filhos, class_name: 'Indicator', foreign_key: 'pai_indicator_id', dependent: :destroy

end
