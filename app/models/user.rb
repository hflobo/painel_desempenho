class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # belongs_to :criador, class_name: :alert
  # belongs_to :destinatario, class_name: :alert
  has_many :alertas_feitos, class_name: 'Alert', foreign_key: 'criador_id', dependent: :destroy
  has_many :alertas_recebidos, class_name: 'Alert', foreign_key: 'destinatario_id', dependent: :destroy
  has_many :indicators
  has_many :dashboards, dependent: :destroy
  has_many :kpis, through: :dashboard
  has_one_attached :photo
end
