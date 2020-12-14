class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :alertas_feitos, class_name: 'Alert', foreign_key: 'criador_id', dependent: :destroy
  has_many :alertas_recebidos, class_name: 'Alert', foreign_key: 'destinatario_id', dependent: :destroy
  has_many :indicators
  has_many :dashboards, dependent: :destroy
  has_many :kpis, through: :dashboard

  validates :name, :email, presence: true
  validates :email, uniqueness: { case_sensitive: false }
end
