class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @wine = Wine.find(params[:wine_id])
    @comment = @wine.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to feed_path, notice: "Comentário enviado!"
    else
      redirect_to feed_path, alert: "Erro ao enviar comentário."
    end
  end

  def destroy
    @wine = Wine.find(params[:wine_id])
    @comment = @wine.comments.find(params[:id])

    # Verifica se o comentário pertence ao usuário logado
    if @comment.user == current_user
        @comment.destroy
        redirect_to feed_path, notice: "Comentário removido!"
    else
        redirect_to feed_path, alert: "Você não tem permissão para apagar este comentário."
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end