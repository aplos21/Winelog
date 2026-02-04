Rails.application.routes.draw do
 # Página inicial do site
  root "wines#index"
  
  # Rota para a Comunidade (ESTA É A LINHA QUE ESTÁ FALTANDO)
  get "comunidade", to: "feed#index", as: :feed
  
  # Rotas de Vinhos, Regiões e Usuários
  resources :wines
  resources :regions
  devise_for :users
  resources :wines do
    resources :comments, only: [:create, :destroy]
  end
end
