class Objective < ApplicationRecord
  has_many :indicators

  validates :tipo, :nome, :descricao, presence: true
end
