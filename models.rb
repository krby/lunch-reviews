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
