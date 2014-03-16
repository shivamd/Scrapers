require 'mechanize'
require 'nokogiri'
require 'debugger'

def agent
  Mechanize.new
end

def get_page(url)
  agent.get(url)
end

page_no = 1
url = "http://allrecipes.com/recipes/main.aspx?evt19=1&st=p&p34=HR_SortByPopularity&Page="
recipe_info_class = ".recipe-info"
rating_class = ".rating-stars-grad" # 5stars = 82px, anything greater than 60px;
title_class = ".title" #href inside recipe-info

recipe_links = []
while page_no < 2100
  page = get_page(url + page_no.to_s)
  recipe_info = page.search(recipe_info_class)
  recipe_info.each do |info|
    if info.search(rating_class).first.attributes["style"].value[6..7].to_i > 57 #more_than_4_stars
      recipe_links << info.search(title_class)[0].attributes["href"].value #add_to_list
    end
  end
  page_no += 1
end

recipe_links.each do |link|
  puts link
end

