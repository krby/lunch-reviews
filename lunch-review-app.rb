require "sinatra"
require "data_mapper"

require "./database_setup"

class User
    include DataMapper::Resource
    
    property :id,           Serial
    property :username,     String, required: true
    property :email,        String, required: true, unique: true
    property :school,       String
    property :grade,        String
    property :password,     BCryptHash
    
    has n, :Reviews, :Comment
end 

class Comment
    include DataMapper::Resource
    
    property :id,           Serial
    property :body,         Text, required: true
    property :likes,        Integer, default: 0
    property :dislikes,     Integer, default: 0
    
    belongs_to :user, :Review
end

class Lunch
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
    property :dislikes,         Integer, default: 0
    property :stars,            Integer, default: 0
    
    belongs_to :user, :Lunch
    has n, :Comment
end

    

