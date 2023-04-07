require "test_helper"

class PlantePartisControllerTest < ActionDispatch::IntegrationTest
  setup do
    @plante_parti = plante_partis(:one)
  end

  test "should get index" do
    get plante_partis_url
    assert_response :success
  end

  test "should get new" do
    get new_plante_parti_url
    assert_response :success
  end

  test "should create plante_parti" do
    assert_difference("PlanteParti.count") do
      post plante_partis_url, params: { plante_parti: { b: @plante_parti.b, c: @plante_parti.c, clasa: @plante_parti.clasa, compozitie: @plante_parti.compozitie, cpl: @plante_parti.cpl, etich: @plante_parti.etich, g1: @plante_parti.g1, g2: @plante_parti.g2, g3: @plante_parti.g3, g4: @plante_parti.g4, g5: @plante_parti.g5, g6: @plante_parti.g6, healthrel: @plante_parti.healthrel, healthrelrom: @plante_parti.healthrelrom, idx: @plante_parti.idx, imaginepp: @plante_parti.imaginepp, imp: @plante_parti.imp, index2: @plante_parti.index2, invpp: @plante_parti.invpp, lucru: @plante_parti.lucru, ordvol: @plante_parti.ordvol, part: @plante_parti.part, parte: @plante_parti.parte, propspeciale: @plante_parti.propspeciale, r: @plante_parti.r, recomandari: @plante_parti.recomandari, s: @plante_parti.s, sel: @plante_parti.sel, selectie: @plante_parti.selectie, selnr: @plante_parti.selnr, selpz: @plante_parti.selpz, selpzn: @plante_parti.selpzn, sels: @plante_parti.sels, selz: @plante_parti.selz, starereprez: @plante_parti.starereprez, t10: @plante_parti.t10, t11: @plante_parti.t11, t12: @plante_parti.t12, t13: @plante_parti.t13, t14: @plante_parti.t14, t15: @plante_parti.t15, t16: @plante_parti.t16, testat: @plante_parti.testat, textsursa: @plante_parti.textsursa, tippp: @plante_parti.tippp, vip: @plante_parti.vip, vir: @plante_parti.vir, z: @plante_parti.z } }
    end

    assert_redirected_to plante_parti_url(PlanteParti.last)
  end

  test "should show plante_parti" do
    get plante_parti_url(@plante_parti)
    assert_response :success
  end

  test "should get edit" do
    get edit_plante_parti_url(@plante_parti)
    assert_response :success
  end

  test "should update plante_parti" do
    patch plante_parti_url(@plante_parti), params: { plante_parti: { b: @plante_parti.b, c: @plante_parti.c, clasa: @plante_parti.clasa, compozitie: @plante_parti.compozitie, cpl: @plante_parti.cpl, etich: @plante_parti.etich, g1: @plante_parti.g1, g2: @plante_parti.g2, g3: @plante_parti.g3, g4: @plante_parti.g4, g5: @plante_parti.g5, g6: @plante_parti.g6, healthrel: @plante_parti.healthrel, healthrelrom: @plante_parti.healthrelrom, idx: @plante_parti.idx, imaginepp: @plante_parti.imaginepp, imp: @plante_parti.imp, index2: @plante_parti.index2, invpp: @plante_parti.invpp, lucru: @plante_parti.lucru, ordvol: @plante_parti.ordvol, part: @plante_parti.part, parte: @plante_parti.parte, propspeciale: @plante_parti.propspeciale, r: @plante_parti.r, recomandari: @plante_parti.recomandari, s: @plante_parti.s, sel: @plante_parti.sel, selectie: @plante_parti.selectie, selnr: @plante_parti.selnr, selpz: @plante_parti.selpz, selpzn: @plante_parti.selpzn, sels: @plante_parti.sels, selz: @plante_parti.selz, starereprez: @plante_parti.starereprez, t10: @plante_parti.t10, t11: @plante_parti.t11, t12: @plante_parti.t12, t13: @plante_parti.t13, t14: @plante_parti.t14, t15: @plante_parti.t15, t16: @plante_parti.t16, testat: @plante_parti.testat, textsursa: @plante_parti.textsursa, tippp: @plante_parti.tippp, vip: @plante_parti.vip, vir: @plante_parti.vir, z: @plante_parti.z } }
    assert_redirected_to plante_parti_url(@plante_parti)
  end

  test "should destroy plante_parti" do
    assert_difference("PlanteParti.count", -1) do
      delete plante_parti_url(@plante_parti)
    end

    assert_redirected_to plante_partis_url
  end
end
