class Cart < ApplicationRecord
  belongs_to :order
  belongs_to :orderitem
  belongs_to :user
end
