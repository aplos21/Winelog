class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  # Adicione esta linha para atualizar o status do usuário
  before_action :update_last_seen_at, if: -> { user_signed_in? }

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nome, :photo])
    devise_parameter_sanitizer.permit(:account_update, keys: [:nome, :photo])
  end

  private

  def update_last_seen_at
    # Atualiza silenciosamente sem mudar o updated_at principal
    current_user.update_column(:last_seen_at, Time.current)
  end
end