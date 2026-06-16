Rails.application.routes.draw do
  # Health check do Rails utilizado pelo Kamal Proxy para validar o deploy
  get "up" => "rails/health#show", as: :rails_health_check

  # Painel de Controle do Administrador (Onde você gerencia os membros)
  namespace :admin do
    resources :users, only: [:index, :destroy] do
      member do
        patch :approve
      end
    end
  end

  # Página inicial do site
  root "wines#index"
  
  # Rota para a Comunidade
  get "comunidade", to: "feed#index", as: :feed
  
  # Rotas de Vinhos, Regiões e Usuários
  resources :regions
  devise_for :users
  
  # Agrupando os recursos de vinhos de forma limpa
  resources :wines do
    resources :comments, only: [:create, :destroy]
  end
end