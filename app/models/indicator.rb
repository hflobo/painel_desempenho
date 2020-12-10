class Indicator < ApplicationRecord
  belongs_to :user
  belongs_to :objective
  belongs_to :region
  belongs_to :indicator
  has_many :kpis, :affiliateds, :goals, :values, :alerts, :responsibles
  has_many :dashboards, through: :kpi
end
