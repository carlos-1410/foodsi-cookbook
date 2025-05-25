module Recipes
  class ToggleFeature
    Result = Struct.new(:success, :value, :status_code)

    def initialize(recipe:, user:)
      @recipe = recipe
      @recipe_author = recipe.author
      @user = user
    end

    def call
      toggle_feature
    end

    private

    attr_reader :recipe, :recipe_author, :user

    def toggle_feature
      return Result.new(false, "Not authorized", :forbidden) unless recipe_author.user_id == user.id

      new_state = !recipe.featured

      if new_state
        if recipe_author.recipes.featured.count >= 3
          return Result.new(false, "Only 3 recipes can be featured", :unprocessable_entity)
        end

        top_10_ids = recipe_author.recipes
          .left_joins(:likes)
          .group("recipes.id")
          .order("COUNT(likes.id) DESC")
          .limit(10)
          .pluck(:id)

        unless top_10_ids.include?(recipe.id)
          return Result.new(false, "Only top 10 recipes by likes can be featured", :unprocessable_entity)
        end
      end

      recipe.update!(featured: new_state)
      Result.new(true, recipe, :success)

    rescue ActiveRecord::RecordInvalid => e
      Result.new(false, e.message, :unprocessable_entity)
    end
  end
end
