class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @wine = Wine.find(params[:wine_id])
    @comment = @wine.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_back fallback_location: root_path, notice: "Enviado com sucesso!"
    else
      redirect_back fallback_location: root_path, alert: "Erro ao publicar."
    end
  end

  def destroy
    # Garante que o usuário só delete o próprio comentário
    @comment = current_user.comments.find(params[:id])
    @comment.destroy
    redirect_back fallback_location: root_path, notice: "Comentário removido."
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :parent_id)
  end
end