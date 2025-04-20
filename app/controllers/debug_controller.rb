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

    def cleanup_duplicate_recipes
        Rails.logger.info "⚙️  Starting duplicate cleanup"

        duplicates = Recipe
                    .group(:title)
                    .having("COUNT(*) > 1")
                    .pluck(:title)

        Rails.logger.info "🔍 Found #{duplicates.size} duplicate titles"

        deleted_count = 0
        batch_size = 100

        duplicates.each_slice(batch_size) do |batch|
            batch.each do |title|
                recipes = Recipe.where(title: title).order(:id)
                recipes_to_delete = recipes.offset(1)
                count = recipes_to_delete.size
                deleted_count += count
                Rails.logger.info "🗑 Deleted #{count} for title '#{title}'"
                recipes_to_delete.destroy_all
            end
        end

        Rails.logger.info "✅ Cleanup finished. Deleted #{deleted_count} records."

        render json: {
            message: "Cleanup complete",
            duplicates_removed: deleted_count
        }
    end
end
