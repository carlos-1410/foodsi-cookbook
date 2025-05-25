class CategoryResource < ApplicationResource
  attribute :name, :string
  attribute :group, :string

  many_to_many :recipes
end
