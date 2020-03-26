# require 'test_helper'
#
# class Gomisa::BrandsControllerTest < ActionDispatch::IntegrationTest
#   setup do
#     @gomisa_brand = gomisa_brands(:one)
#   end
#
#   test "should get index" do
#     get gomisa_brands_url
#     assert_response :success
#   end
#
#   test "should get new" do
#     get new_gomisa_brand_url
#     assert_response :success
#   end
#
#   test "should create gomisa_brand" do
#     assert_difference('Gomisa::Brand.count') do
#       post gomisa_brands_url, params: { gomisa_brand: {  } }
#     end
#
#     assert_redirected_to gomisa_brand_url(Gomisa::Brand.last)
#   end
#
#   test "should show gomisa_brand" do
#     get gomisa_brand_url(@gomisa_brand)
#     assert_response :success
#   end
#
#   test "should get edit" do
#     get edit_gomisa_brand_url(@gomisa_brand)
#     assert_response :success
#   end
#
#   test "should update gomisa_brand" do
#     patch gomisa_brand_url(@gomisa_brand), params: { gomisa_brand: {  } }
#     assert_redirected_to gomisa_brand_url(@gomisa_brand)
#   end
#
#   test "should destroy gomisa_brand" do
#     assert_difference('Gomisa::Brand.count', -1) do
#       delete gomisa_brand_url(@gomisa_brand)
#     end
#
#     assert_redirected_to gomisa_brands_url
#   end
# end
