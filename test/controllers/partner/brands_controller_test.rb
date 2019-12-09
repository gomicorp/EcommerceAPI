require 'test_helper'

class Partner::BrandsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @partner_brand = partner_brands(:one)
  end

  test "should get index" do
    get partner_brands_url
    assert_response :success
  end

  test "should get new" do
    get new_partner_brand_url
    assert_response :success
  end

  test "should create partner_brand" do
    assert_difference('Partner::Brand.count') do
      post partner_brands_url, params: { partner_brand: {  } }
    end

    assert_redirected_to partner_brand_url(Partner::Brand.last)
  end

  test "should show partner_brand" do
    get partner_brand_url(@partner_brand)
    assert_response :success
  end

  test "should get edit" do
    get edit_partner_brand_url(@partner_brand)
    assert_response :success
  end

  test "should update partner_brand" do
    patch partner_brand_url(@partner_brand), params: { partner_brand: {  } }
    assert_redirected_to partner_brand_url(@partner_brand)
  end

  test "should destroy partner_brand" do
    assert_difference('Partner::Brand.count', -1) do
      delete partner_brand_url(@partner_brand)
    end

    assert_redirected_to partner_brands_url
  end
end
