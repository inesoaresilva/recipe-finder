class RecipesController < ApplicationController
  def index
    # renders app/views/recipes/index.html.erb
  end

  def search
    if params[:ingredients].present?
      searched_ingredients = params[:ingredients]
      .split(",")
      .map(&:strip)
      .reject(&:blank?)
      .map(&:downcase)

      ingredient_query = searched_ingredients.map { "name ILIKE ?" }.join(" OR ")
      ingredient_values = searched_ingredients.map { |term| "%#{term}%" }

      matched_ingredients = Ingredient
        .where(ingredient_query, *ingredient_values)
        .pluck(:id)

      if matched_ingredients.empty?
        matched_ingredients = searched_ingredients.flat_map do |term|
          Ingredient.search_by_name(term).pluck(:id)
        end.uniq
      end

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

      recipe_matches = recipe_matches.distinct.offset(start).limit(per_page)

      render json: recipe_matches, include: :ingredients
    else
      render json: Recipe.includes(:ingredients).all
    end
  end
end
