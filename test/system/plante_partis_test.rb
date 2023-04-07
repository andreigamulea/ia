require "application_system_test_case"

class PlantePartisTest < ApplicationSystemTestCase
  setup do
    @plante_parti = plante_partis(:one)
  end

  test "visiting the index" do
    visit plante_partis_url
    assert_selector "h1", text: "Plante partis"
  end

  test "should create plante parti" do
    visit plante_partis_url
    click_on "New plante parti"

    fill_in "B", with: @plante_parti.b
    fill_in "C", with: @plante_parti.c
    fill_in "Clasa", with: @plante_parti.clasa
    fill_in "Compozitie", with: @plante_parti.compozitie
    fill_in "Cpl", with: @plante_parti.cpl
    fill_in "Etich", with: @plante_parti.etich
    fill_in "G1", with: @plante_parti.g1
    fill_in "G2", with: @plante_parti.g2
    fill_in "G3", with: @plante_parti.g3
    fill_in "G4", with: @plante_parti.g4
    fill_in "G5", with: @plante_parti.g5
    fill_in "G6", with: @plante_parti.g6
    fill_in "Healthrel", with: @plante_parti.healthrel
    fill_in "Healthrelrom", with: @plante_parti.healthrelrom
    fill_in "Idx", with: @plante_parti.idx
    fill_in "Imaginepp", with: @plante_parti.imaginepp
    fill_in "Imp", with: @plante_parti.imp
    fill_in "Index2", with: @plante_parti.index2
    fill_in "Invpp", with: @plante_parti.invpp
    fill_in "Lucru", with: @plante_parti.lucru
    fill_in "Ordvol", with: @plante_parti.ordvol
    fill_in "Part", with: @plante_parti.part
    fill_in "Parte", with: @plante_parti.parte
    fill_in "Propspeciale", with: @plante_parti.propspeciale
    fill_in "R", with: @plante_parti.r
    fill_in "Recomandari", with: @plante_parti.recomandari
    fill_in "S", with: @plante_parti.s
    fill_in "Sel", with: @plante_parti.sel
    fill_in "Selectie", with: @plante_parti.selectie
    fill_in "Selnr", with: @plante_parti.selnr
    fill_in "Selpz", with: @plante_parti.selpz
    fill_in "Selpzn", with: @plante_parti.selpzn
    fill_in "Sels", with: @plante_parti.sels
    fill_in "Selz", with: @plante_parti.selz
    fill_in "Starereprez", with: @plante_parti.starereprez
    fill_in "T10", with: @plante_parti.t10
    fill_in "T11", with: @plante_parti.t11
    fill_in "T12", with: @plante_parti.t12
    fill_in "T13", with: @plante_parti.t13
    fill_in "T14", with: @plante_parti.t14
    fill_in "T15", with: @plante_parti.t15
    fill_in "T16", with: @plante_parti.t16
    fill_in "Testat", with: @plante_parti.testat
    fill_in "Textsursa", with: @plante_parti.textsursa
    fill_in "Tippp", with: @plante_parti.tippp
    fill_in "Vip", with: @plante_parti.vip
    fill_in "Vir", with: @plante_parti.vir
    fill_in "Z", with: @plante_parti.z
    click_on "Create Plante parti"

    assert_text "Plante parti was successfully created"
    click_on "Back"
  end

  test "should update Plante parti" do
    visit plante_parti_url(@plante_parti)
    click_on "Edit this plante parti", match: :first

    fill_in "B", with: @plante_parti.b
    fill_in "C", with: @plante_parti.c
    fill_in "Clasa", with: @plante_parti.clasa
    fill_in "Compozitie", with: @plante_parti.compozitie
    fill_in "Cpl", with: @plante_parti.cpl
    fill_in "Etich", with: @plante_parti.etich
    fill_in "G1", with: @plante_parti.g1
    fill_in "G2", with: @plante_parti.g2
    fill_in "G3", with: @plante_parti.g3
    fill_in "G4", with: @plante_parti.g4
    fill_in "G5", with: @plante_parti.g5
    fill_in "G6", with: @plante_parti.g6
    fill_in "Healthrel", with: @plante_parti.healthrel
    fill_in "Healthrelrom", with: @plante_parti.healthrelrom
    fill_in "Idx", with: @plante_parti.idx
    fill_in "Imaginepp", with: @plante_parti.imaginepp
    fill_in "Imp", with: @plante_parti.imp
    fill_in "Index2", with: @plante_parti.index2
    fill_in "Invpp", with: @plante_parti.invpp
    fill_in "Lucru", with: @plante_parti.lucru
    fill_in "Ordvol", with: @plante_parti.ordvol
    fill_in "Part", with: @plante_parti.part
    fill_in "Parte", with: @plante_parti.parte
    fill_in "Propspeciale", with: @plante_parti.propspeciale
    fill_in "R", with: @plante_parti.r
    fill_in "Recomandari", with: @plante_parti.recomandari
    fill_in "S", with: @plante_parti.s
    fill_in "Sel", with: @plante_parti.sel
    fill_in "Selectie", with: @plante_parti.selectie
    fill_in "Selnr", with: @plante_parti.selnr
    fill_in "Selpz", with: @plante_parti.selpz
    fill_in "Selpzn", with: @plante_parti.selpzn
    fill_in "Sels", with: @plante_parti.sels
    fill_in "Selz", with: @plante_parti.selz
    fill_in "Starereprez", with: @plante_parti.starereprez
    fill_in "T10", with: @plante_parti.t10
    fill_in "T11", with: @plante_parti.t11
    fill_in "T12", with: @plante_parti.t12
    fill_in "T13", with: @plante_parti.t13
    fill_in "T14", with: @plante_parti.t14
    fill_in "T15", with: @plante_parti.t15
    fill_in "T16", with: @plante_parti.t16
    fill_in "Testat", with: @plante_parti.testat
    fill_in "Textsursa", with: @plante_parti.textsursa
    fill_in "Tippp", with: @plante_parti.tippp
    fill_in "Vip", with: @plante_parti.vip
    fill_in "Vir", with: @plante_parti.vir
    fill_in "Z", with: @plante_parti.z
    click_on "Update Plante parti"

    assert_text "Plante parti was successfully updated"
    click_on "Back"
  end

  test "should destroy Plante parti" do
    visit plante_parti_url(@plante_parti)
    click_on "Destroy this plante parti", match: :first

    assert_text "Plante parti was successfully destroyed"
  end
end
