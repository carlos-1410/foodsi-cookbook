class RecipesController < ApplicationController
  before_action :recipe, only: [:like, :unlike, :mark_featured]
  before_action :authenticate_user!, except: [:index]

  def index
    RecipeResource.new.with_context(current_user: current_user) do
      recipes = RecipeResource.all(params)
      respond_with(recipes)
    end
  end

  # By default returns author's recipes
  def stats
    results = Recipes::Stats.call(
      author: current_user.author,
      group_by: params[:group_by],
      created_after: params[:created_after],
      created_before: params[:created_before]
    )

    render json: results
  end

  def show
    recipe = RecipeResource.find(params)
    respond_with(recipe)
  end

  def like
    recipe.likes.find_or_create_by(user_id: current_user.id)
    respond_with_resource(RecipeResource, recipe)
  end

  def unlike
    recipe.likes.destroy_by(user_id: current_user.id)
    respond_with_resource(RecipeResource, recipe)
  end

  def feature
    result = Recipes::ToggleFeature.new(recipe: recipe, user: current_user).call

    unless result.success
      return render json: { error: result.value }, status: result.status_code
    end

    respond_with_resource(RecipeResource, result.value)
  end

  private

  def recipe
    @recipe ||= Recipe.find(params[:id])
  end
end
