class RecipesController < ApplicationController
  def index
    # renders app/views/recipes/index.html.erb
  end

  def search
    if params[:ingredients].present?
      searched_ingredients = params[:ingredients].split(",").map(&:strip).reject(&:blank?).map(&:downcase)

      matched_ingredients = searched_ingredients.flat_map do |ingredient_name|
        Ingredient.search_by_name(ingredient_name)
      end.uniq

      return render json: [] if matched_ingredients.empty?

      start = params[:start].to_i
      per_page = 10

      recipe_matches = Recipe
      .joins(:ingredients)
      .where(ingredients: { id: matched_ingredients })
      .select("recipes.*, COUNT(DISTINCT ingredients.id) AS match_count")
      .group("recipes.id")
      .order("match_count DESC")

      if params[:max_time].present?
        recipe_matches = recipe_matches.where(
        "COALESCE(prep_time, 0) + COALESCE(cook_time, 0) <= ?",
        params[:max_time].to_i
      )
      end

      recipe_matches = recipe_matches.offset(start).limit(per_page)

      render json: recipe_matches, include: :ingredients
    else
      render json: Recipe.includes(:ingredients).all
    end
  end
end
