class RecipeResource < ApplicationResource
  attribute :title, :string
  attribute :text, :string
  attribute :difficulty, :string
  attribute :preparation_time, :integer
  attribute :created_at, :datetime
  attribute :likes_count, :integer

  belongs_to :author
  many_to_many :categories

  filter :liked_by_current_user, :boolean do
    eq do |scope, value|
      if value && context[:current_user]
        scope.joins(:likes).where(likes: { user_id: context[:current_user].id }).distinct
      elsif !value && context[:current_user]
        scope.left_outer_joins(:likes)
             .where.not(likes: { user_id: context[:current_user].id })
             .or(scope.where.missing(:likes))
             .distinct
      else
        Recipe.none # that's because without applying any filters, index returns recipes
      end
    end
  end
end
