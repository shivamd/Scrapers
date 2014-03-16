require 'mechanize'
require 'nokogiri'
require 'debugger'

def agent
  Mechanize.new
end

def get_page(url)
  agent.get(url)
end

main_url = "http://allrecipes.com"
name_id = "#itemTitle"
image_id = "#imgPhoto"
servings_id = "#lblYield"
ingredients_class = ".fl-ing"
ingredient_amount_class = ".ingredient-amount"
ingredient_name_class = ".ingredient-name"
directions_class = ".directions ol li span"

recipes = []
f = File.open("recipe_urls.txt", "r")
f.each_line do |recipe_url|
  recipe = {}
  page = get_page(main_url + recipe_url)
  recipe["name"] = page.search(name_id).inner_text
  recipe["image"] = page.search(image_id).first.attributes["src"].value
  recipe["servings"] = page.search(servings_id).inner_text.gsub(" servings", "").to_i
  recipe["ingredients"] = []
  recipe["directions"] = []
  ingredients = page.search(ingredients_class)
  ingredients.each do |ingredient|
    amount = ingredient.search(ingredient_amount_class).children[0]
    name = ingredient.search(ingredient_name_class).children[0]
    if amount && name #some recipes have empty ingredients
      quantity,unit = amount.text.split(" ")
      recipe["ingredients"] << { "quantity" => quantity.to_f, "unit"=>unit, "name" => name.text }
    end
  end
  directions = page.search(directions_class)
  directions.each do |direction|
    recipe["directions"] << direction.text
  end
  recipes << recipe

  File.open("recipes.json","w") do |f|
    f.write(recipes.to_json)
  end

end
f.close
