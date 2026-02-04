class FeedController < ApplicationController
  before_action :authenticate_user!

  def index
    # 1. Carregamos todos os usuários para a aba lateral
    # Ordenamos primeiro por quem está online (last_seen_at recente)
    @users = User.all.order(last_seen_at: :desc)

    # 2. Sua lógica original de vinhos (Feed)
    @wines = Wine.includes(
      :tags, 
      :photo_attachment, 
      user: { photo_attachment: :blob }, 
      comments: { user: { photo_attachment: :blob } }
    ).order(created_at: :desc)

    # 3. Sua lógica original de busca
    if params[:query].present?
      search_query = "%#{params[:query]}%"
      @wines = @wines.left_joins(:user, :tags).where(
        "wines.name ILIKE :q OR 
         wines.local ILIKE :q OR 
         tags.name ILIKE :q OR 
         users.nome ILIKE :q OR 
         to_char(wines.created_at, 'DD/MM/YYYY') ILIKE :q", 
        q: search_query
      ).distinct
    end
  end
end