class CategoriesController < ApplicationController
  def index
    categories = CategoryResource.all(params)
    respond_with(categories)
  end
end
