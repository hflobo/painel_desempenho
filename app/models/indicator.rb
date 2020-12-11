class Indicator < ApplicationRecord
  belongs_to :user
  belongs_to :objective
  belongs_to :region
  belongs_to :indicator
  has_many :kpis
  has_many :affiliateds
  has_many :goals
  has_many :values
  has_many :alerts
  has_many :responsibles
  has_many :dashboards, through: :kpi
end
