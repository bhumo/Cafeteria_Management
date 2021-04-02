class User < ApplicationRecord
  has_secure_password
  validates :password_digest, presence: true, confirmation: true
  validates_confirmation_of :password_digest
  validates :name, presence: true, uniqueness: true
  validates :role, presence: true
  validates :status, presence: true
end
