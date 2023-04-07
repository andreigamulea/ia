require "test_helper"

class RecomandarisControllerTest < ActionDispatch::IntegrationTest
  setup do
    @recomandari = recomandaris(:one)
  end

  test "should get index" do
    get recomandaris_url
    assert_response :success
  end

  test "should get new" do
    get new_recomandari_url
    assert_response :success
  end

  test "should create recomandari" do
    assert_difference("Recomandari.count") do
      post recomandaris_url, params: { recomandari: { completari: @recomandari.completari, idp: @recomandari.idp, idpp: @recomandari.idpp, idpr: @recomandari.idpr, imp: @recomandari.imp, listaproprietati_id: @recomandari.listaproprietati_id, propayur: @recomandari.propayur, propeng: @recomandari.propeng, propgerm: @recomandari.propgerm, proprietate: @recomandari.proprietate, sel: @recomandari.sel, srota: @recomandari.srota, sursa: @recomandari.sursa, tipp: @recomandari.tipp } }
    end

    assert_redirected_to recomandari_url(Recomandari.last)
  end

  test "should show recomandari" do
    get recomandari_url(@recomandari)
    assert_response :success
  end

  test "should get edit" do
    get edit_recomandari_url(@recomandari)
    assert_response :success
  end

  test "should update recomandari" do
    patch recomandari_url(@recomandari), params: { recomandari: { completari: @recomandari.completari, idp: @recomandari.idp, idpp: @recomandari.idpp, idpr: @recomandari.idpr, imp: @recomandari.imp, listaproprietati_id: @recomandari.listaproprietati_id, propayur: @recomandari.propayur, propeng: @recomandari.propeng, propgerm: @recomandari.propgerm, proprietate: @recomandari.proprietate, sel: @recomandari.sel, srota: @recomandari.srota, sursa: @recomandari.sursa, tipp: @recomandari.tipp } }
    assert_redirected_to recomandari_url(@recomandari)
  end

  test "should destroy recomandari" do
    assert_difference("Recomandari.count", -1) do
      delete recomandari_url(@recomandari)
    end

    assert_redirected_to recomandaris_url
  end
end
