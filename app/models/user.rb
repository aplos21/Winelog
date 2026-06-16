class User < ApplicationRecord
  # IMPORTANTE: Removemos o :confirmable daqui para o cadastro ser 100% direto e sem e-mails travando
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_one_attached :photo
  has_many :wines, dependent: :destroy
  has_many :comments, dependent: :destroy

  # Trava de login: O usuário se cadastra normalmente, mas só faz login se você mudar 'approved' para true
  def active_for_authentication?
    super && approved?
  end
end