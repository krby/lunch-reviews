require "sinatra"
require "data_mapper"

require "./database_setup"

helpers do
	
end

class User
	include DataMapper::Resource
	
	property :id,           Serial
	property :username,     String, required: true
	property :email,        String, required: true, unique: true
	property :school,       String
	property :grade,        String
	property :password,     BCryptHash
	
	has n, :Reviews
end

class Lunch # the actual lunch item of the day
	include DataMapper::Resource
	
	property :id,       Serial
	property :name,     String, required: true
	property :date,     DateTime, required: true # the date that the item is lunch
	
	has n, :MenuItem 
	
end

class MenuItem 
	include DataMapper::Resource
	
	property :id,       Serial
	property :name,     String, required: true
	property :title,    Text, required: true
	property :body,     Text, required: true
	
	has n, :Review

end

class Review
	include DataMapper::Resource
	
	property :id,               Serial 
	property :title,            Text
	property :body,             Text, required: true
	property :created_at,       DateTime, required: true
	property :likes,            Integer, default: 0
	
	# rating??? should it be like this???
	property :stars,            Integer, default: 0
	
	belongs_to :user, :Lunch
end

get("/") do
  erb(:index)
end

	

