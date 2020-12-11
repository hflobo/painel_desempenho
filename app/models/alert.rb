class Alert < ApplicationRecord
  belongs_to :indicator
  belongs_to :criador, class_name: 'User'
  belongs_to :destinatario, class_name: 'User'
end
