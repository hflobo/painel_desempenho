class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :criador, class_name: :alert
  belongs_to :destinatario, class_name: :alert
  has_many :alerts
  has_many :affiliateds
  has_many :indicators
  has_many :responsibles
  has_many :dashboards
  has_many :kpis, through: :dashboard
end
