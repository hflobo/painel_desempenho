class Dashboard < ApplicationRecord
  belongs_to :user
  has_many :kpis, dependent: :destroy

  validates :nome, presence: true
  validates :nome, uniqueness: { scope: :user_id, case_sensitive: false,
                                 message: "Usuário já possui um painel com este nome" }
end
