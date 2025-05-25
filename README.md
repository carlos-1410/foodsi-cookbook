# README

Food Recipes API is a simple API for managing recipes with categories, and authors. 
The API is built using Ruby on Rails and uses JSON:API standard.

## Ruby and Rails Version
* Ruby version: 3.0.7
* Rails version: 7.0.8.4

## Setup Steps
Clone the repository:  
```
git clone <repository_url>
cd <repository_name>
```
Install dependencies:  
```
bundle install
```
Set up the database:  
```
rails db:create
rails db:migrate
rails db:seed
```
Run the server:  
```
rails server
```
Run tests:  
```
bundle exec rspec
```

## Tasks to Solve
### 1. Implement Likes:
    - User must be able to like a recipe.
    `POST localhost:3000/api/v1/recipes/:recipe_id/like`

    - User must be able to unlike a recipe.
    `POST localhost:3000/api/v1/recipes/:recipe_id/unlike`

    - User must be able to get a list of recipes they have liked.
    `GET localhost:3000/api/v1/recipes?filter[liked_by_current_user]=[true|false]`

    - Likes count need to be display on recipe index page. [CHECK]
### 2. Add Stats for Recipes Grouped by Week/Month:
    Add a way to get stats (recipes count and total likes) for author recipes grouped by 
    - category
    `GET localhost:3000/api/v1/recipes/stats?group_by=category`
    - week/month of creation.
    ```
    GET localhost:3000/api/v1/recipes/stats?group_by=week
    GET localhost:3000/api/v1/recipes/stats?group_by=month
    ```
    additionally, I've added a filter by date (created_before, created_after)
    `GET localhost:3000/api/v1/recipes/stats?created_after=2025-05-01&created_before=2025-05-20`
### 3. Add Featured Recipes:
    Add an endpoint for authors to mark and unmark their recipes as "featured" with constraints:
    - up to 3 featured recipes at one time
    - the recipe is in the top 10 by likes count for the author
    ```
    PUT localhost:3000/api/v1/recipes/:recipe_id/feature
    ```

## Existing Endpoints
* GET /recipes
* GET /recipes/:id
* GET /categories
* GET /authors
* GET /authors/:id
