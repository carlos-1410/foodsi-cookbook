# Create categories
puts 'Creating categories'
%w[Breakfast Lunch Dinner Snack Dessert Drink].each do |category|
  Category.find_or_create_by!(name: category, group: :dish_type)
  print '.'
end
%w[Italian Mexican Japanese Indian Chinese].each do |category|
  Category.find_or_create_by!(name: category, group: :cuisine)
  print '.'
end
%w[Vegan Vegetarian Gluten-Free].each do |category|
  Category.find_or_create_by!(name: category, group: :diet)
  print '.'
end
%w[Christmas Birthday BBQ Picnic].each do |category|
  Category.find_or_create_by!(name: category, group: :occasion)
  print '.'
end

# Create authors
puts "\nCreating authors"
authors = (1..1_000).map do |i|
  print '.'
  Author.create(
    name: Faker::Name.name,
    bio: Faker::Lorem.paragraph,
    fb: Faker::Internet.username,
    ig: Faker::Internet.username,
    user: User.create(nickname: Faker::Internet.username)
  )
end

categories = Category.all

# Create sample recipes
puts "\nCreating recipes"
recipes = (1..100_000).map do |i|
  print '.'
  Recipe.new(
    title: "Recipe #{i} - #{Faker::Food.dish}",
    text: "Description #{i} - #{Faker::Food.description}",
    preparation_time: rand(1..120),
    difficulty: Recipe.difficulties.keys.sample,
    author_id: authors.sample.id,
    categories: categories.sample(rand(1..3))
  )
end

recipes.each_slice(50_000) do |batch|
  Recipe.import batch, on_duplicate_key_update: %i[title text preparation_time difficulty], validate: false, recursive: true
  print '.'
end

categories = Category.all
# Assign categories to recipes
puts "\nAssigning categories to recipes"
Recipe.all.in_batches(of: 10_000) do |all_recipes|
  print '.'
  recipe_categories = all_recipes.flat_map do |recipe|
    (1..rand(1..3)).map do
      RecipeCategory.new(
        recipe: recipe,
        category: categories.sample
      )
    end
  end

  RecipeCategory.import recipe_categories, validate: false
end

