class RecipesController < ApplicationController
  def index
    # renders app/views/recipes/index.html.erb
  end

  def search
    query = params[:query]
    if query.present?
      @recipes = Recipe.includes(:ingredients).search_by_title_and_ingredients(query)
    else
      @recipes = Recipe.includes(:ingredients).all
    end

    render json: @recipes, include: :ingredients
  end
end
