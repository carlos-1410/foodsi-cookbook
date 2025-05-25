require 'rails_helper'

RSpec.describe Recipes::Stats, type: :service do
  let(:author) { create(:author) }

  describe ".call" do
    it "returns a default grouped summary when no params are passed" do
      create_list(:recipe, 3, author: author)
      result = described_class.call(author: author)

      expect(result).to be_an(Array)
      expect(result.first).to include(:group, :recipes_count, :likes_count)
    end

    it "filters by created_after" do
      create(:recipe, author: author, created_at: 1.week.ago)
      create(:recipe, author: author, created_at: 1.day.ago)

      result = described_class.call(author: author, created_after: 2.days.ago)

      total_count = result.sum { |row| row[:recipes_count] }
      expect(total_count).to eq(1)
    end

    it "filters by created_before" do
      create(:recipe, author: author, created_at: 1.week.ago)
      create(:recipe, author: author, created_at: 1.day.ago)

      result = described_class.call(author: author, created_before: 2.days.ago)

      total_count = result.sum { |row| row[:recipes_count] }
      expect(total_count).to eq(1)
    end

    context "with :category grouping" do
      it "groups by category name" do
        cat1 = create(:category, name: "Breakfast")
        cat2 = create(:category, name: "Dinner")

        create(:recipe, author: author, categories: [cat1])
        create(:recipe, author: author, categories: [cat1, cat2])
        create(:recipe, author: author, categories: [cat2])

        result = described_class.call(author: author, group_by: :category)

        expect(result.size).to eq(2)
        labels = result.map { |r| r[:group] }
        expect(labels).to include("Breakfast", "Dinner")
      end
    end

    context "with :week grouping" do
      it "groups recipes by week" do
        create(:recipe, author: author, created_at: 2.weeks.ago)
        create(:recipe, author: author, created_at: Time.current)

        result = described_class.call(author: author, group_by: :week)

        expect(result.map { |r| r[:group] }).to all(match(/\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}(\.\d+)?/))
        expect(result.sum { |r| r[:recipes_count] }).to eq(2)
      end
    end

    context "with :month grouping" do
      it "groups recipes by month" do
        create(:recipe, author: author, created_at: 2.months.ago)
        create(:recipe, author: author, created_at: Time.current)

        result = described_class.call(author: author, group_by: :month)

        expect(result.map { |r| r[:group] }).to all(match(/\d{4}-\d{2}/))
        expect(result.sum { |r| r[:recipes_count] }).to eq(2)
      end
    end

    it "parses valid and invalid date strings" do
      valid = described_class.new(author: author, created_after: "2025-01-01")
      invalid = described_class.new(author: author, created_after: "not-a-date")

      expect(valid.instance_variable_get(:@created_after)).to eq(Date.new(2025, 1, 1))
      expect(invalid.instance_variable_get(:@created_after)).to be_nil
    end
  end
end
