class ImportController < ApplicationController
    def ingredient_count
        count = Ingredient.count
        render plain: "Total ingredients: #{count}"
      end
      
    def recipes
        require "json"
        require "set"

        file_path = Rails.root.join("public", "recipes-en.json")

        batch_size = 1000

        ActiveRecord::Base.transaction do
            recipes_data = JSON.parse(File.read(file_path))

            recipe_batch = []
            ingredient_batch = []
            ingredient_names = Set.new
            recipe_ingredients_batch = []

            Rails.logger.info "Importing recipes from #{file_path}..."

            recipes_data.each do |recipe_data|
                recipe = {
                    title: recipe_data["title"],
                    cook_time: recipe_data["cook_time"],
                    prep_time: recipe_data["prep_time"],
                    ratings: recipe_data["ratings"],
                    cuisine: recipe_data["cuisine"],
                    category: recipe_data["category"],
                    author: recipe_data["author"],
                    image: recipe_data["image"]
                }

                recipe_batch << recipe

                recipe_data["ingredients"].each { |ingredient| ingredient_names.add(ingredient) }

                if recipe_batch.size >= batch_size
                    Recipe.insert_all(recipe_batch)
                    recipe_batch.clear
                end
            end

            Recipe.insert_all(recipe_batch) unless recipe_batch.empty?
            recipe_batch

            Rails.logger.info "Imported #{recipes_data.size} recipes."
            Rails.logger.info "Importing ingredients..."

            existing_ingredients = Ingredient.pluck(:name).to_set
            ingredient_names.subtract(existing_ingredients)
            ingredient_names.each do |name|
                ingredient_batch << { name: name }

                if ingredient_batch.size >= batch_size
                    Ingredient.insert_all(ingredient_batch)
                    ingredient_batch.clear
                end
            end
            Ingredient.insert_all(ingredient_batch) unless ingredient_batch.empty?
            Rails.logger.info "Imported #{ingredient_names.size} ingredients."

            recipe_ids = Recipe.pluck(:title, :id).to_h
            ingredient_ids = Ingredient.pluck(:name, :id).to_h

            recipes_data.each do |recipe_data|
                recipe_id = recipe_ids[recipe_data["title"]]

                recipe_data["ingredients"].each do |ingredient_name|
                    ingredient_id = ingredient_ids[ingredient_name]

                    recipe_ingredients_batch << { recipe_id: recipe_id, ingredient_id: ingredient_id }

                    if recipe_ingredients_batch.size >= batch_size
                        RecipeIngredient.insert_all(recipe_ingredients_batch)
                        recipe_ingredients_batch.clear
                    end
                end
            end
            RecipeIngredient.insert_all(recipe_ingredients_batch) unless recipe_ingredients_batch.empty?
            Rails.logger.info "Imported RecipeIngredients table."

            render plain: "Imported #{recipes_data.size} recipes and #{ingredient_names.size} ingredients."
        end
    end
end
