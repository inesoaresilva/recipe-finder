class RecipesController < ApplicationController
  def index
    # renders app/views/recipes/index.html.erb
  end

  def search
    if params[:ingredients].present?
      searched_ingredients = params[:ingredients].split(",").map(&:strip)

      matched_ingredients = searched_ingredients.flat_map do |ingredient_name|
        Ingredient.search_by_name(ingredient_name)
      end.uniq

      recipe_matches = Recipe
      .joins(:ingredients)
      .where(ingredients: { id: matched_ingredients })
      .select("recipes.*, COUNT(ingredients.id) AS match_count")
      .group("recipes.id")
      .order("match_count DESC")

      render json: recipe_matches, include: :ingredients
    else
      render json: Recipe.includes(:ingredients).all
    end
  end
end
