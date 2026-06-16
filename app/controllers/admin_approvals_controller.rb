class AdminApprovalsController < ApplicationController
  # Esse endpoint não exige que você esteja logado para ser acionado pelo e-mail, 
  # pois usamos o token único do usuário para validar a autenticidade da requisição.
  def approve
    user = User.find(params[:id])

    # Garante segurança comparando o token da URL com o token salvo no banco
    if user && user.confirmation_token == params[:token]
      user.update(approved: true)
      render plain: "Sucesso! O usuário #{user.email} foi aprovado e já pode logar no Winelog."
    else
      render plain: "Acesso negado ou token de aprovação inválido.", status: :unauthorized
    end
  end
end