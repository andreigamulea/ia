require "test_helper"

class ListaproprietatisControllerTest < ActionDispatch::IntegrationTest
  setup do
    @listaproprietati = listaproprietatis(:one)
  end

  test "should get index" do
    get listaproprietatis_url
    assert_response :success
  end

  test "should get new" do
    get new_listaproprietati_url
    assert_response :success
  end

  test "should create listaproprietati" do
    assert_difference("Listaproprietati.count") do
      post listaproprietatis_url, params: { listaproprietati: { definire: @listaproprietati.definire, idx: @listaproprietati.idx, proprietateter: @listaproprietati.proprietateter, sel: @listaproprietati.sel, selectie: @listaproprietati.selectie, sinonime: @listaproprietati.sinonime, srota: @listaproprietati.srota, tipp: @listaproprietati.tipp } }
    end

    assert_redirected_to listaproprietati_url(Listaproprietati.last)
  end

  test "should show listaproprietati" do
    get listaproprietati_url(@listaproprietati)
    assert_response :success
  end

  test "should get edit" do
    get edit_listaproprietati_url(@listaproprietati)
    assert_response :success
  end

  test "should update listaproprietati" do
    patch listaproprietati_url(@listaproprietati), params: { listaproprietati: { definire: @listaproprietati.definire, idx: @listaproprietati.idx, proprietateter: @listaproprietati.proprietateter, sel: @listaproprietati.sel, selectie: @listaproprietati.selectie, sinonime: @listaproprietati.sinonime, srota: @listaproprietati.srota, tipp: @listaproprietati.tipp } }
    assert_redirected_to listaproprietati_url(@listaproprietati)
  end

  test "should destroy listaproprietati" do
    assert_difference("Listaproprietati.count", -1) do
      delete listaproprietati_url(@listaproprietati)
    end

    assert_redirected_to listaproprietatis_url
  end
end
