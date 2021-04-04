class User < ApplicationRecord
  has_secure_password
  has_many :order
  has_many :cart
  validates :password_digest, presence: true, confirmation: true
  validates_confirmation_of :password_digest
  validates :name, presence: true, uniqueness: true
  validates :role, presence: true
  validates :status, presence: true
end
