class WinesController < ApplicationController
  before_action :authenticate_user!
  
  # Garante segurança: você só edita/deleta o que é seu
  before_action :set_author_wine, only: %i[ edit update destroy ]
  before_action :set_wine, only: %i[ show ]

  def index
    # 1. Definimos o ponto de partida (neste caso, vinhos do usuário logado)
    @wines = current_user.wines.order(created_at: :desc)

    # 2. O FILTRO DEVE FICAR AQUI: Dentro do método index
    if params[:query].present?
      # Usando o scope que criamos no Model Wine
      @wines = @wines.search_by_all(params[:query])
    end
  end

  def show
  end

  def new
    @wine = current_user.wines.build
  end

  def edit
    # O set_author_wine já faz o trabalho de carregar o vinho aqui
  end

  def create
    @wine = current_user.wines.build(wine_params)

    if @wine.save
      redirect_to wines_path, notice: "Vinho cadastrado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @wine.update(wine_params)
      redirect_to wines_path, notice: "Vinho atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @wine.destroy
    redirect_to wines_path, notice: "Vinho removido da sua adega."
  end

  private

  def set_author_wine
    @wine = current_user.wines.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to wines_path, alert: "Você não tem permissão para esta ação."
  end

  def set_wine
    @wine = Wine.find(params[:id])
  end

  def wine_params
    params.require(:wine).permit(:name, :description, :rating, :local, :photo, tag_ids: [])
  end
end