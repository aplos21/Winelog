class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :wine

  # Estas linhas resolvem o NoMethodError
  belongs_to :parent, class_name: 'Comment', optional: true
  has_many :replies, class_name: 'Comment', foreign_key: :parent_id, dependent: :destroy

  validates :content, presence: true
end