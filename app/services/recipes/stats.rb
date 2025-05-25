# app/services/recipes/stats_filterer.rb
module Recipes
  class Stats
    def initialize(author:, base_scope: nil, group_by: nil, created_after: nil, created_before: nil)
      @group_by = group_by&.to_sym
      @created_after = parse_date(created_after)
      @created_before = parse_date(created_before)
      @base_scope = base_scope || author&.recipes.eager_load(:likes) || Recipe.none
      @scope = @base_scope
    end

    def self.call(**args)
      new(**args).call
    end

    def call
      apply_created_after_filter
      apply_created_before_filter
      apply_group_by_filter

      @scope
    end

    private

    def apply_created_after_filter
      return unless @created_after

      @scope = @scope.where(Recipe.arel_table[:created_at].gteq(@created_after))
    end

    def apply_created_before_filter
      return unless @created_before

      @scope = @scope.where(Recipe.arel_table[:created_at].lteq(@created_before))
    end

    def apply_group_by_filter
      @scope =
        case @group_by
        when :category
          @scope
            .joins(:categories)
            .left_joins(:likes)
            .group("categories.name")
            .select("categories.name AS group_label, COUNT(DISTINCT recipes.id) AS recipes_count, COUNT(likes.id) AS likes_count")
        when :week
          @scope
            .left_joins(:likes)
            .group_by_week(:created_at, format: "%Y-W%U")
            .select("MIN(recipes.created_at) AS group_date, COUNT(DISTINCT recipes.id) AS recipes_count, COUNT(likes.id) AS likes_count")
        when :month
          @scope
            .left_joins(:likes)
            .group_by_month(:created_at, format: "%Y-%m")
            .select("MIN(recipes.created_at) AS group_date, COUNT(DISTINCT recipes.id) AS recipes_count, COUNT(likes.id) AS likes_count")
        else
          @scope
            .left_joins(:likes)
            .select("COUNT(DISTINCT recipes.id) AS recipes_count, COUNT(likes.id) AS likes_count")
        end.map do
          group_label = if @group_by
            @group_by == :category ? _1.group_label : _1.group_date || _1.group_date&.strftime("%Y-%m-%d")
          else
            "All"
          end

          # Stats themselves
          {
            group: group_label,
            recipes_count: _1.recipes_count,
            likes_count: _1.likes_count
          }
        end
    end

    def parse_date(value)
      return if value.blank?
      return value if value.is_a?(Date) || value.is_a?(Time)

      Date.parse(value.to_s)
    rescue ArgumentError
      nil
    end
  end
end
