class Product < ApplicationRecord
  # Validations
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }

  validates :quantity, presence: true, numericality: { greater_than: 0 }, if: :new_record?
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }, unless: :new_record?
end
