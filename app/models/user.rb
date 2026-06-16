class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
         
  has_one_attached :photo
  has_many :wines, dependent: :destroy
  has_many :comments, dependent: :destroy

  # 1. Trava o login: o usuário só entra se estiver confirmado E aprovado por você
  def active_for_authentication?
    super && approved?
  end

  # 2. Define a mensagem customizada que o Devise vai exibir caso ele tente logar sem aprovação
  def inactive_message
    approved? ? super : :not_approved
  end

  # 3. Gatilho automático: assim que o usuário clica no e-mail dele e se confirma,
  # o Rails dispara a notificação com os botões para o mms1@icomp.ufam.edu.br
  def after_confirmation
    super
    AdminMailer.new_user_waiting_approval(self).deliver_now
  end
end