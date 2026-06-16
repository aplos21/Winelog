class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!

  # Lista todos os usuários cadastrados
  def index
    @users = User.order(created_at: :desc)
  end

  # Ativa o usuário
  def approve
    @user = User.find(params[:id])
    @user.update(approved: true)
    redirect_to admin_users_path, notice: "Usuário #{@user.email} aprovado com sucesso!"
  end

  # Deleta o usuário do sistema
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path, notice: "Usuário deletado com sucesso."
  end

  private

  # Trava de segurança máxima: Só você entra aqui
  def ensure_admin!
    unless current_user.email == 'mms1@icomp.ufam.edu.br'
      redirect_to root_path, alert: "Acesso negado! Você não é o administrador."
    end
  end
end