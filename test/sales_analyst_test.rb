require './test/test_helper'
require './lib/sales_engine'
require './test/test_data'

class SalesAnalystTest < Minitest::Test
  include TestData, TestSetup

  def setup
    make_some_test_data
    se = SalesEngine.new(@itemr,@mr,@ir,@iir,@cr,@tr)
    @sa = se.analyst
  end

  def test_top_buyers_passing_number
    @sa.top_buyers
  end

  def test_average_items_per_merchant
    setup_fixtures
    assert_equal 4.86, @sa.average_items_per_merchant
  end

  def test_average_items_per_merchant_standard_deviation
    setup_fixtures
    assert_equal 6.91, @sa.average_items_per_merchant_standard_deviation
  end

  def test_average_item_price_for_merchant
    setup_fixtures
    assert_equal 0.8, @sa.average_item_price_for_merchant(12334235)
  end

  def test_average_average_price_per_merchant
    setup_fixtures
    assert_equal 0.88, @sa.average_average_price_per_merchant
  end

  def test_golden_items
    setup_fixtures
    assert_equal 0, @sa.golden_items.length
  end

  def test_average_invoices_per_merchant
    setup_fixtures
    assert_equal 10.43, @sa.average_invoices_per_merchant
  end

  def test_average_invoices_per_merchant_standard_deviation
    setup_fixtures
    assert_equal 4.79, @sa.average_invoices_per_merchant_standard_deviation
  end

  def test_top_days_by_invoice_count
    setup_fixtures
    assert_equal [], @sa.top_days_by_invoice_count
  end
  #iteration 4 tests

  def test_revenue_by_date
    setup_empty_sales_engine
    time = Time.parse('2014-03-04')
    @se.merchants.create(id: 1, name: "King Soopers")
    @se.merchants.create(id: 2, name: "Amazon")
    @se.merchants.create(id: 3, name: "Bob's Burgers")
    @se.merchants.create(id: 4, name: "JC")
    @se.items.create(id: 1, name: 'burger', merchant_id: '3', unit_price: BigDecimal(500), merchant_id: 3)
    @se.items.create(id: 2, name: "3D printed Jaguar", unit_price: BigDecimal(100_000_00), merchant_id: 4)
    @se.items.create(id: 3, name: "3D printed packing peanut", unit_price: BigDecimal(1), merchant_id: 4)

    @se.invoices.create(id: 1, customer_id: 1, merchant_id: 4, status: :shipped, created_at: time)
    @se.invoice_items.create(id: 1, item_id: 2, invoice_id: 1, unit_price: BigDecimal(100_000_00), quantity: 2)
    @se.invoice_items.create(id: 2, item_id: 3, invoice_id: 1, unit_price: BigDecimal(1), quantity: 5)
    @se.transactions.create(id:1, invoice_id: 1, credit_card_number: 2, result: :success, credit_card_expiration_date: Time.now)

    @se.invoices.create(id: 2, customer_id: 1, merchant_id: 3, status: :shipped, created_at: time)
    @se.invoice_items.create(id: 1, item_id: 1, invoice_id: 2, unit_price: BigDecimal(500), quantity: 200)
    @se.transactions.create(id:1, invoice_id: 2, credit_card_number: 2, result: :success, credit_card_expiration_date: Time.now)

    assert_equal 201_000_05, @sa.total_revenue_by_date(time)
  end

  def test_successful_invoices
    setup_empty_sales_engine

    @sa.invoices.create(id: 1, customer_id: 1, merchant_id: 3, status: :shipped, created_at: Time.new(2013, 10))
    @sa.invoices.create(id: 2, customer_id: 1, merchant_id: 3, status: :pending, created_at: Time.new(2013, 10))
    @sa.transactions.create(id:3, invoice_id: 1, credit_card_number: 2, result: :success, credit_card_expiration_date: Time.now)

    actual = @sa.successful_invoices
    assert_instance_of Invoice, actual[0]
    assert_equal 1, actual.size
    assert_equal 1, actual[0].id
  end

  def test_customers_with_unpaid_invoices
    actual = @sa.customers_with_unpaid_invoices
    assert_equal 2, actual.size
  end

  def test_get_transaction_count_for
    setup_empty_sales_engine
    @sa.invoices.create(id: 1, customer_id: 1, merchant_id: 1, status: :shipped, created_at: Time.new(2013, 10))
    @sa.invoices.create(id: 2, customer_id: 1, merchant_id: 1, status: :pending, created_at: Time.new(2013, 10))

    @se.invoice_items.create(id: 1, item_id: 2, invoice_id: 1, unit_price: BigDecimal(100_000_00), quantity: 2)

    @sa.transactions.create(id:1, invoice_id: 1, credit_card_number: 2, result: :success, credit_card_expiration_date: Time.now)
    @sa.transactions.create(id:2, invoice_id: 1, credit_card_number: 2, result: :success, credit_card_expiration_date: Time.now)

    assert_equal 2, @sa.get_transaction_count_for(@se.invoice_items.find_by_id(1))
  end
end
