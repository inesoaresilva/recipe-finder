class AddFullTextSearchIndexes < ActiveRecord::Migration[8.0]
  def change
    execute <<-SQL
    CREATE INDEX index_recipes_on_title_tsvector
    ON recipes
    USING gin (to_tsvector('english', title));
  SQL

  execute <<-SQL
      CREATE INDEX index_ingredients_on_name_tsvector
      ON ingredients
      USING gin (to_tsvector('english', name));
    SQL
  end
end
