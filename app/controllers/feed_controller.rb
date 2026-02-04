class FeedController < ApplicationController
  before_action :authenticate_user!

  def index
    @wines = Wine.includes(
      :tags, 
      :photo_attachment, 
      user: { photo_attachment: :blob }, 
      comments: { user: { photo_attachment: :blob } }
    ).order(created_at: :desc)

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