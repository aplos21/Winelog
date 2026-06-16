class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
         
  has_one_attached :photo
  has_many :wines, dependent: :destroy
  has_many :comments, dependent: :destroy

  # Executa antes de salvar o usuário no banco pela primeira vez
  before_create :auto_confirm_user

  # Trava de login: Só entra se for aprovado por você
  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    approved? ? super : :not_approved
  end

  private

  # Pula a necessidade de enviar o e-mail do Devise, confirmando o usuário na hora
  def auto_confirm_user
    self.skip_confirmation!
  end
end