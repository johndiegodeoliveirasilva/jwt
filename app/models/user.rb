# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :email, uniqueness: true
  validates :email, format: { with: /@/ }
  validates :password_digest, presence: true
end
