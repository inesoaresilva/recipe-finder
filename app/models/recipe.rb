class Recipe < ApplicationRecord
    include PgSearch::Model

    pg_search_scope :search_by_title_and_ingredients,
        against: [ :title ],
        associated_against: { ingredients: [ :name ] },
        using: { tsearch: { prefix: true } }

    has_many :recipe_ingredients, dependent: :destroy
    has_many :ingredients, through: :recipe_ingredients
end
