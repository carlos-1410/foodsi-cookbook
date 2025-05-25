class AuthorResource < ApplicationResource
  attribute :name, :string
  attribute :bio, :string
  attribute :fb, :string
  attribute :ig, :string

  has_many :recipes
end
