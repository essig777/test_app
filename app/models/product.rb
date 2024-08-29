class Product < ApplicationRecord
  belongs_to :category

  validates :description, :price, :category, presence: true

  def full_decription
    "#{self.description} - #{self.price}"
    # Produto1 - 1.20
  end
end
