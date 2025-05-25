class AuthorsController < ApplicationController
  def index
    authors = AuthorResource.all(params)
    respond_with(authors)
  end

  def show
    author = AuthorResource.find(params)
    respond_with(author)
  end
end
