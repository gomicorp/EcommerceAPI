# require 'test_helper'
#
# class Gomisa::CompaniesControllerTest < ActionDispatch::IntegrationTest
#   setup do
#     @gomisa_company = gomisa_companies(:one)
#   end
#
#   test "should get index" do
#     get gomisa_companies_url
#     assert_response :success
#   end
#
#   test "should get new" do
#     get new_gomisa_company_url
#     assert_response :success
#   end
#
#   test "should create gomisa_company" do
#     assert_difference('Gomisa::Company.count') do
#       post gomisa_companies_url, params: { gomisa_company: {  } }
#     end
#
#     assert_redirected_to gomisa_company_url(Gomisa::Company.last)
#   end
#
#   test "should show gomisa_company" do
#     get gomisa_company_url(@gomisa_company)
#     assert_response :success
#   end
#
#   test "should get edit" do
#     get edit_gomisa_company_url(@gomisa_company)
#     assert_response :success
#   end
#
#   test "should update gomisa_company" do
#     patch gomisa_company_url(@gomisa_company), params: { gomisa_company: {  } }
#     assert_redirected_to gomisa_company_url(@gomisa_company)
#   end
#
#   test "should destroy gomisa_company" do
#     assert_difference('Gomisa::Company.count', -1) do
#       delete gomisa_company_url(@gomisa_company)
#     end
#
#     assert_redirected_to gomisa_companies_url
#   end
# end
