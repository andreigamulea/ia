require "application_system_test_case"

class An32324sTest < ApplicationSystemTestCase
  setup do
    @an32324 = an32324s(:one)
  end

  test "visiting the index" do
    visit an32324s_url
    assert_selector "h1", text: "An32324s"
  end

  test "should create an32324" do
    visit an32324s_url
    click_on "New an32324"

    fill_in "Apr", with: @an32324.apr
    fill_in "Dec", with: @an32324.dec
    fill_in "Email", with: @an32324.email
    fill_in "Feb", with: @an32324.feb
    fill_in "Ian", with: @an32324.ian
    fill_in "Iul", with: @an32324.iul
    fill_in "Iun", with: @an32324.iun
    fill_in "Mai", with: @an32324.mai
    fill_in "Mar", with: @an32324.mar
    fill_in "Nov", with: @an32324.nov
    fill_in "Nume", with: @an32324.nume
    fill_in "Oct", with: @an32324.oct
    fill_in "Pret", with: @an32324.pret
    fill_in "Sep", with: @an32324.sep
    fill_in "Telefon", with: @an32324.telefon
    click_on "Create An32324"

    assert_text "An32324 was successfully created"
    click_on "Back"
  end

  test "should update An32324" do
    visit an32324_url(@an32324)
    click_on "Edit this an32324", match: :first

    fill_in "Apr", with: @an32324.apr
    fill_in "Dec", with: @an32324.dec
    fill_in "Email", with: @an32324.email
    fill_in "Feb", with: @an32324.feb
    fill_in "Ian", with: @an32324.ian
    fill_in "Iul", with: @an32324.iul
    fill_in "Iun", with: @an32324.iun
    fill_in "Mai", with: @an32324.mai
    fill_in "Mar", with: @an32324.mar
    fill_in "Nov", with: @an32324.nov
    fill_in "Nume", with: @an32324.nume
    fill_in "Oct", with: @an32324.oct
    fill_in "Pret", with: @an32324.pret
    fill_in "Sep", with: @an32324.sep
    fill_in "Telefon", with: @an32324.telefon
    click_on "Update An32324"

    assert_text "An32324 was successfully updated"
    click_on "Back"
  end

  test "should destroy An32324" do
    visit an32324_url(@an32324)
    click_on "Destroy this an32324", match: :first

    assert_text "An32324 was successfully destroyed"
  end
end
