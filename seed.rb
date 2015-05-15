require_relative "environment"

DEFAULT_MENU_ITEMS = [
  {
    name: "Chili on a Stick",
    description: "Warning: Very Messy. I Don't even know why we have it."
  },
  {
    name: "PEANUT",
    description: "Not roasted"
  }
]

DEFAULT_MENU_ITEMS.each do |menu_item_data|
  puts "Creating #{menu_item_data[:name]}..."
  MenuItem.create(menu_item_data)
end
