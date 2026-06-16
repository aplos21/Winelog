class AdminMailer < ApplicationMailer
  default from: 'no-reply@winelog.com'

  def new_user_waiting_approval(user)
    @user = user
    # Link direto para a ação de aprovação (usando o token gerado para segurança)
    @approve_url = approve_user_url(id: @user.id, token: @user.confirmation_token)

    mail(
      to: 'mms1@icomp.ufam.edu.br', 
      subject: "[Winelog] Novo membro aguardando aprovação: #{@user.email}"
    )
  end
end