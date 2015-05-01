# the actual lunch item of the day
class Lunch 
	include DataMapper::Resource
	
	property :id,       Serial
	property :date,     Date, required: true # the date that the item is lunch

	has n, :lunch_menu_items
	has n, :menu_items, through: :lunch_menu_items
	
  def add_menu_item_ids(menu_item_ids)
    if menu_item_ids
      menu_item_ids.each do |menu_item_id|
        self.menu_items << MenuItem.get(menu_item_id)
      end
    end
  end
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

  property :email, String,
    :format   => :email_address,
    :required => true,
    :unique   => true,
    :messages => {
      :format => "You must enter a valid email address."
    }
  property :password, BCryptHash, :required => true
  validates_confirmation_of :password
  
  attr_accessor :password_confirmation
  validates_length_of :password_confirmation, :min => 6
  
  
  def valid_password?(unhashed_password)
    self.password == unhashed_password
  end
  
  def self.find_by_email(email)
    self.first(:email => email)
  end
  
	has n, :reviews
end

DataMapper.finalize
DataMapper.auto_upgrade!