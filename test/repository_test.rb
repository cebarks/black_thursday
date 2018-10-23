require './test/test_helper.rb'
require './lib/repository'

class RepositoryTest < Minitest::Test
  GenericObject = Struct.new(:name, :id)

  def setup
    @rep = Repository.new

    @ob1 = GenericObject.new("bob", 4)
    @ob2 = GenericObject.new("deb", 3)
    @ob3 = GenericObject.new("john", 2)
    @ob4 = GenericObject.new("john", 1)
    @ob5 = GenericObject.new("bill", 5)
  end

  def test_it_exists
    assert_instance_of Repository, @rep
  end

  def test_all_returns_an_empty_array_by_default
    assert_equal [], @rep.all
  end

  def test_find_by_id_returns_nil_if_no_items
    assert_nil @rep.find_by_id(1)
  end

  def test_find_by_id_returns_found_instance
    @rep.create(@ob2)
    @rep.create(@ob3)
    @rep.create(@ob4)
    @rep.create(@ob5)
    assert_equal @ob5, @rep.find_by_id(5)
  end

  def test_find_by_name_returns_nil_if_no_items
    assert_nil @rep.find_by_name("Name of something")
  end

  def test_find_by_id_returns_instance_with_name
    @rep.create(@ob1)
    @rep.create(@ob2)
    @rep.create(@ob3)
    @rep.create(@ob4)

    assert_equal @ob3, @rep.find_by_name("john")
  end

  def test_find_all_by_name_returns_an_empty_array_if_none_found
    assert_equal [], @rep.find_all_by_name("name")
  end

  def test_find_all_by_name_returns_matched_objects_by_name
    @rep.create(@ob1)
    @rep.create(@ob2)
    @rep.create(@ob3)
    @rep.create(@ob4)

    assert_equal [@ob3, @ob4], @rep.find_all_by_name("john")
  end

  def test_create_adds_instances_to_array
    @rep.create(@ob1)
    @rep.create(@ob2)
    @rep.create(@ob3)
    @rep.create(@ob4)
    @rep.create(@ob5)

    expected = [@ob1, @ob2, @ob3, @ob4, @ob5]

    assert_equal expected, @rep.all
  end

  def test_deleting_by_id_removes_instance
    @rep.create(@ob1)
    @rep.create(@ob2)
    @rep.create(@ob3)
    @rep.create(@ob4)
    @rep.create(@ob5)

    @rep.delete(5)

    expected = [@ob1, @ob2, @ob3, @ob4]

    assert_equal expected, @rep.all
  end

end


# - all - returns an array of all known Merchant instances
# - find_by_id(id) - returns either nil or an instance of Merchant with a matching ID
# - find_by_name(name) - returns either nil or an instance of Merchant having done a case insensitive search
#
# - find_all_by_name(name) - returns either [] or one or more matches which contain the supplied name fragment, case insensitive
# - create(attributes) - create a new Merchant instance with the provided attributes. The new Merchant’s id should be the current highest Merchant id plus 1.
# - delete(id) - delete the Merchant instance with the corresponding id
