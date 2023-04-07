require "application_system_test_case"

class ListaproprietatisTest < ApplicationSystemTestCase
  setup do
    @listaproprietati = listaproprietatis(:one)
  end

  test "visiting the index" do
    visit listaproprietatis_url
    assert_selector "h1", text: "Listaproprietatis"
  end

  test "should create listaproprietati" do
    visit listaproprietatis_url
    click_on "New listaproprietati"

    fill_in "Definire", with: @listaproprietati.definire
    fill_in "Idx", with: @listaproprietati.idx
    fill_in "Proprietateter", with: @listaproprietati.proprietateter
    fill_in "Sel", with: @listaproprietati.sel
    fill_in "Selectie", with: @listaproprietati.selectie
    fill_in "Sinonime", with: @listaproprietati.sinonime
    fill_in "Srota", with: @listaproprietati.srota
    fill_in "Tipp", with: @listaproprietati.tipp
    click_on "Create Listaproprietati"

    assert_text "Listaproprietati was successfully created"
    click_on "Back"
  end

  test "should update Listaproprietati" do
    visit listaproprietati_url(@listaproprietati)
    click_on "Edit this listaproprietati", match: :first

    fill_in "Definire", with: @listaproprietati.definire
    fill_in "Idx", with: @listaproprietati.idx
    fill_in "Proprietateter", with: @listaproprietati.proprietateter
    fill_in "Sel", with: @listaproprietati.sel
    fill_in "Selectie", with: @listaproprietati.selectie
    fill_in "Sinonime", with: @listaproprietati.sinonime
    fill_in "Srota", with: @listaproprietati.srota
    fill_in "Tipp", with: @listaproprietati.tipp
    click_on "Update Listaproprietati"

    assert_text "Listaproprietati was successfully updated"
    click_on "Back"
  end

  test "should destroy Listaproprietati" do
    visit listaproprietati_url(@listaproprietati)
    click_on "Destroy this listaproprietati", match: :first

    assert_text "Listaproprietati was successfully destroyed"
  end
end
