require "sinatra"
require "data_mapper"

require "./environment"

helpers do
end

get("/") do
  erb(:main_page, { locals: {lunch: Lunch.last}})
end


# Add menu items into database. 
get("/add_menu_items") do
	list = MenuItem.all(order: :name.asc)
	erb(:add_menu_items, locals: { menu_items: list })
end

post("/add_menu_item") do
  menu_item_name = params["name"]
  menu_item_desc = params["description"]
  
  menu_item = MenuItem.create(
    name: 							menu_item_name,
    description: 				menu_item_desc
  )
 
  if menu_item.saved?
    redirect("/")
  else
		erb(:add_menu_items, locals: { menu_items: list })
  end
end


# Set the lunch. Enter in what the lunch is. 
get("/set_lunch") do
	list = MenuItem.all(order: :name.asc)
	erb(:set_lunch, locals: {menu_items: list})
end

post("/set_lunch") do
	puts "#############"
	puts "#############"
	p params["menu_item_id"]
	stuff = params["menu_item_id"]
	mItem = MenuItem.get(stuff)
	puts mItem.name
	puts mItem.description
	puts params["date"]
	lunch = Lunch.new(
		date: 			params["date"]
	)
	lunch.menu_items << mItem
	lunch.save()
	if lunch.saved?
  	redirect("/")
  else
		erb(:error)
	end
end