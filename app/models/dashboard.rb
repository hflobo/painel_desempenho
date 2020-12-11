class Dashboard < ApplicationRecord
  belongs_to :user
  has_many :kpis, dependent: :destroy
end
