class ComenziProd1 < ApplicationRecord
  belongs_to :prod
  belongs_to :comanda
  belongs_to :user, optional: true
  end
  