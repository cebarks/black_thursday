require_relative 'repository'
require_relative 'item'

class ItemRepository < Repository
  def create(args)
    super(Item.new(args))
  end

  def find_all_with_description(description)
    @instances.find_all {|item| item.description == description}
  end
end
