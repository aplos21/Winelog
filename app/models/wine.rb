class Wine < ApplicationRecord
  belongs_to :user

  
  # Active Storage (para o campo :photo do seu formulário)
  has_one_attached :photo
  
  # Taggings (para o campo :tag_ids do seu formulário)
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :comments, dependent: :destroy

  # Validações básicas
  validates :name, :rating, presence: true
  validates :rating, inclusion: { in: 1..5 }
end