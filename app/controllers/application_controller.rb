class ApplicationController < ActionController::Base
  # Este filtro ativa as permissões extras para o Devise
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # :nome tem de estar nestas duas listas exatas
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nome, :photo])
    devise_parameter_sanitizer.permit(:account_update, keys: [:nome, :photo])
  end
end