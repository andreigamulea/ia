require "application_system_test_case"

class ContractesTest < ApplicationSystemTestCase
  setup do
    @contracte = contractes(:one)
  end

  test "visiting the index" do
    visit contractes_url
    assert_selector "h1", text: "Contractes"
  end

  test "should create contracte" do
    visit contractes_url
    click_on "New contracte"

    fill_in "Contor", with: @contracte.contor
    fill_in "Denumire", with: @contracte.denumire
    fill_in "Email", with: @contracte.email
    fill_in "Textcontract", with: @contracte.textcontract
    fill_in "Tip", with: @contracte.tip
    fill_in "User", with: @contracte.user_id
    click_on "Create Contracte"

    assert_text "Contracte was successfully created"
    click_on "Back"
  end

  test "should update Contracte" do
    visit contracte_url(@contracte)
    click_on "Edit this contracte", match: :first

    fill_in "Contor", with: @contracte.contor
    fill_in "Denumire", with: @contracte.denumire
    fill_in "Email", with: @contracte.email
    fill_in "Textcontract", with: @contracte.textcontract
    fill_in "Tip", with: @contracte.tip
    fill_in "User", with: @contracte.user_id
    click_on "Update Contracte"

    assert_text "Contracte was successfully updated"
    click_on "Back"
  end

  test "should destroy Contracte" do
    visit contracte_url(@contracte)
    click_on "Destroy this contracte", match: :first

    assert_text "Contracte was successfully destroyed"
  end
end
