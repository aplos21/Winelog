class Wine < ApplicationRecord
  belongs_to :user

  # Active Storage
  has_one_attached :photo
  
  # Associações para Tags e Comentários
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :comments, dependent: :destroy

  # Validações
  validates :name, :rating, presence: true
  
  # Alterado para aceitar floats (decimais) entre 1 e 5
  validates :rating, numericality: { 
    greater_than_or_equal_to: 1, 
    less_than_or_equal_to: 5 
  }

  # --- LÓGICA PARA RECEBER STRING DE TAGS ---

  def tag_list
    tags.map(&:name).join(", ")
  end

  def tag_list=(names)
    self.tags = names.split(",").map do |name|
      Tag.where(name: name.strip.downcase).first_or_create!
    end.uniq
  end
end