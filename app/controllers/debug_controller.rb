class DebugController < ApplicationController
    def duplicate_recipes
        duplicates = Recipe
                    .group(:title)
                    .having("COUNT(*) > 1")
                    .count
                    .sort_by { |_, count| -count }

        total = Recipe.count
        distinct = Recipe.select(:title).distinct.count

        render json: {
            total_recipes: total,
            distinct_titles: distinct,
            duplicate_titles: duplicates
        }
    end
end
