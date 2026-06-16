class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
         
  has_one_attached :photo
  has_many :wines, dependent: :destroy
  has_many :comments, dependent: :destroy

  # Pula a confirmação de e-mail e confirma no banco na hora do cadastro
  before_create :auto_confirm_user

  # Trava de login: Só entra se for aprovado por você
  def active_for_authentication?
    super && approved?
  end

  private

  def auto_confirm_user
    self.skip_confirmation!
  end
end