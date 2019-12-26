require "application_system_test_case"

class Gomisa::CompaniesTest < ApplicationSystemTestCase
  setup do
    @gomisa_company = gomisa_companies(:one)
  end

  test "visiting the index" do
    visit gomisa_companies_url
    assert_selector "h1", text: "Gomisa/Companies"
  end

  test "creating a Company" do
    visit gomisa_companies_url
    click_on "New Gomisa/Company"

    click_on "Create Company"

    assert_text "Company was successfully created"
    click_on "Back"
  end

  test "updating a Company" do
    visit gomisa_companies_url
    click_on "Edit", match: :first

    click_on "Update Company"

    assert_text "Company was successfully updated"
    click_on "Back"
  end

  test "destroying a Company" do
    visit gomisa_companies_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Company was successfully destroyed"
  end
end
