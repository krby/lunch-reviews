require "sinatra"
require "data_mapper"

require "./database_setup"

helpers do
end


# the actual lunch item of the day
class Lunch 
	include DataMapper::Resource
	
	property :id,       Serial
	property :date,     Date, required: true # the date that the item is lunch
	# property :name,     String, required: true
	
	has n, :lunch_menu_items
	has n, :menu_items, through: :lunch_menu_items
end

# Pairs lunch (date specific) and menu items
# Allows for the many-many relationship
class LunchMenuItem
	include DataMapper::Resource

	property :id, Serial
	
	belongs_to :menu_item
	belongs_to :lunch
end

class MenuItem 
	include DataMapper::Resource
	
	property :id,								Serial
	property :name,							String, required: true # name of the menu item
	property :description,			Text, required: true

	
	has n, :review
	has n, :lunch_menu_items
	has n, :lunches, through: :lunch_menu_items
end




class Review
	include DataMapper::Resource
	
	property :id,               Serial 
	property :body,             Text, required: true
	property :created_at,       DateTime, required: true
	property :likes,            Integer, default: 0
	property :stars,            Integer, required: true
	property :summary,          String
	
	belongs_to :user, :menu_item
end

class User
	include DataMapper::Resource
	
	property :id,           Serial
	property :email,        String, required: true, unique: true
	property :password,     BCryptHash
	
	has n, :reviews
end

DataMapper.finalize
DataMapper.auto_upgrade!

get("/") do
  erb(:main_page)
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
	gg = params["menu_item_id"]
	mItem = MenuItem.get(gg)
	puts mItem.name
	
	lunch = Lunch.create(
		
	)
	
	if lunch.saved?
  	redirect("/")
  else
		erb(:error)
	end
end