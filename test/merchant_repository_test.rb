require './test/test_helper'
require './lib/merchant_repository'

class MerchantRepositoryTest < Minitest::Test

  def setup
    @mr = MerchantRepository.new
  end

  def test_it_exists
    assert_instance_of MerchantRepository, @mr
  end

  def test_create_adds_merchant
    @mr.create("Mr. Merchant")
    assert_equal 1, @mr.all.size
    assert_equal 1, @mr.all[0].id
    assert_equal "Mr. Merchant", @mr.all[0].name
  end

  def test_create_adds_merchants
    @mr.create("Mr. Merchant")
    assert_equal 1, @mr.all.size
    assert_equal 1, @mr.all[0].id
    assert_equal "Mr. Merchant", @mr.all[0].name
    @mr.create("Mrs. Merchant")
    assert_equal 2, @mr.all.size
    assert_equal 2, @mr.find_by_name("Mrs. Merchant").id
    assert_equal "Mrs. Merchant", @mr.find_by_id(2).name

  end

end
