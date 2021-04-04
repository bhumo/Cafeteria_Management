class Orderitem < ApplicationRecord
  belongs_to :order
  belongs_to :menuitem
  has_many :cart
end
