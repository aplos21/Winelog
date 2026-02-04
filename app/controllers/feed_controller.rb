class FeedController < ApplicationController
  before_action :authenticate_user!

  def index
    @wines = Wine.includes(
      :tags, 
      :photo_attachment, 
      user: { photo_attachment: :blob }, 
      comments: { user: { photo_attachment: :blob } }
    ).order(created_at: :desc)
  end
end