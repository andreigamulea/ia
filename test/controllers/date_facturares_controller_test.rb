require "test_helper"

class DateFacturaresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @date_facturare = date_facturares(:one)
  end

  test "should get index" do
    get date_facturares_url
    assert_response :success
  end

  test "should get new" do
    get new_date_facturare_url
    assert_response :success
  end

  test "should create date_facturare" do
    assert_difference("DateFacturare.count") do
      post date_facturares_url, params: { date_facturare: { adresaemail: @date_facturare.adresaemail, altedate: @date_facturare.altedate, codpostal: @date_facturare.codpostal, cpa: @date_facturare.cpa, cui: @date_facturare.cui, email: @date_facturare.email, firma_id: @date_facturare.firma_id, grupa2324: @date_facturare.grupa2324, judet: @date_facturare.judet, localitate: @date_facturare.localitate, numar: @date_facturare.numar, nume: @date_facturare.nume, numecompanie: @date_facturare.numecompanie, prenume: @date_facturare.prenume, strada: @date_facturare.strada, tara: @date_facturare.tara, telefon: @date_facturare.telefon, user_id: @date_facturare.user_id } }
    end

    assert_redirected_to date_facturare_url(DateFacturare.last)
  end

  test "should show date_facturare" do
    get date_facturare_url(@date_facturare)
    assert_response :success
  end

  test "should get edit" do
    get edit_date_facturare_url(@date_facturare)
    assert_response :success
  end

  test "should update date_facturare" do
    patch date_facturare_url(@date_facturare), params: { date_facturare: { adresaemail: @date_facturare.adresaemail, altedate: @date_facturare.altedate, codpostal: @date_facturare.codpostal, cpa: @date_facturare.cpa, cui: @date_facturare.cui, email: @date_facturare.email, firma_id: @date_facturare.firma_id, grupa2324: @date_facturare.grupa2324, judet: @date_facturare.judet, localitate: @date_facturare.localitate, numar: @date_facturare.numar, nume: @date_facturare.nume, numecompanie: @date_facturare.numecompanie, prenume: @date_facturare.prenume, strada: @date_facturare.strada, tara: @date_facturare.tara, telefon: @date_facturare.telefon, user_id: @date_facturare.user_id } }
    assert_redirected_to date_facturare_url(@date_facturare)
  end

  test "should destroy date_facturare" do
    assert_difference("DateFacturare.count", -1) do
      delete date_facturare_url(@date_facturare)
    end

    assert_redirected_to date_facturares_url
  end
end
