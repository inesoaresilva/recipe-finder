class RecipesController < ApplicationController
  def search
    query = params[:query]
    if query.present?
      @recipes = Recipe.search_by_title_and_ingredients(query)
    else
      @recipes = Recipe.all
    end

    render json: @recipes, include: :ingredients
  end
end
