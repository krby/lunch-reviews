require "sinatra"
require "data_mapper"

require "./environment"

helpers do
  def current_user
    # Return nil if no user is logged in
    return nil unless session.key?(:user_id)

    # If @current_user is undefined, define it by
    # fetching it from the database.
    @current_user ||= User.get(session[:user_id])
  end

  def user_signed_in?
    # A user is signed in if the current_user method
    # returns something other than nil
    !current_user.nil?
  end

  def sign_in!(user)
    session[:user_id] = user.id
    @current_user = user
  end

  def sign_out!
    @current_user = nil
    session.delete(:user_id)
  end
end

set(:sessions, true)
set(:session_secret, ENV["SESSION_SECRET"])

get("/") do
  # Lunch.last.menu_items.each do |menu_item|
  #     if menu_item.reviews.empty?

  #     else
  #         if menu_item.reviews.count > 2
  #         menu_item.reviews.first.destroy
  #         else
  #           print "##########################"
  #         end
  #     end
  #   end
  
	users = User.all
  erb(:main_page, :locals => {:lunch => Lunch.last, :users => users})
end

get("/users/new") do
  user = User.new
  erb(:users_new, :locals => { :user => user })
end

post("/users") do
  user = User.create(params[:user])

  if user.saved?
    sign_in!(user)

    redirect("/")
  else
    erb(:users_new, :locals => { :user => user })
  end
end

get("/sessions/new") do
  user = User.new
  erb(:sessions_new, :locals => { :user => user })
end

post("/sessions") do
  user = User.find_by_email(params[:email])

  if user && user.valid_password?(params[:password])
    sign_in!(user)
    redirect("/")
  else
    erb(:sessions_new, :locals => { :user => user })
  end
end

get("/sessions/sign_out") do
  sign_out!
  redirect("/")
end




# LUNCH REVIEW specific (non user-auth)
# Add menu items into database. 
get("/admin/add_menu_items") do
	list = MenuItem.all(order: :name.asc)
	erb(:add_menu_items, locals: { menu_items: list })
end

# Add menu item
post("/admin/add_menu_item") do
  menu_item_name = params["name"]
  menu_item_desc = params["description"]
  
  menu_item = MenuItem.create(
    name: 							menu_item_name,
    description: 				menu_item_desc
  )
 
  if menu_item.saved?
    redirect("/admin/add_menu_items")
  else
		erb(:error)
  end
end

# delete menu item 
post("/admin/delete_menu_item/:menu_item_id") do
  menu_item = MenuItem.get(params["menu_item_id"])
  menu_item.destroy
  
  if menu_item.destroyed?
    redirect("/admin/add_menu_items")
  else
    menu_item.errors.each do |error|
      p #############
      p error
    end
		erb(:error)
  end
end

# Set lunch page
get("/admin/set_lunch") do
	list = MenuItem.all(order: :name.asc)
	erb(:set_lunch, locals: {menu_items: list})
end

# Set the lunch. Enter in what the lunch is. 
post("/admin/set_lunch") do
  lunch = Lunch.new(date: params["date"])
  
  #.add_menu_item_ids method is added in the Lunch class in models.rb
  lunch.add_menu_item_ids(params["menu_item_ids"])
  
	if lunch.save
  	redirect("/")
  else
		erb(:error)
	end
end

# Rate a MenuItem
post("/review/:menu_item_id") do
  rating = params["menu_item_rating"].to_i
  body = params["menu_item_review_body"]
  puts "#################################"
  puts "#################################"
  puts body
  
  review = Review.new(
    body:             body,
  	rating: 					rating,
  	created_at: 			DateTime.now
  )
  MenuItem.get(params["menu_item_id"]).reviews << review
  
	if review.save
		redirect("/")
	else
		puts "something went horribly wrong"
		review.errors.each do |error|
			p error
		end
		erb(:error)
	end
end