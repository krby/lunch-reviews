# Lunch Reviews
What's for lunch?  
Something Good?


ruby lunch-review-app.rb -o $IP

irb -r./environment

Seed.rb is for all the necessary things for our program to run as Jesse said.

lunch = Lunch.new(date: "2015-4-25")
lunch.add_menu_item_ids(["1", "2"])


user = User.find_by_email("kirby@kirby.com")
user.admin = true
user.save