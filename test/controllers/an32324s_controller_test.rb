require "test_helper"

class An32324sControllerTest < ActionDispatch::IntegrationTest
  setup do
    @an32324 = an32324s(:one)
  end

  test "should get index" do
    get an32324s_url
    assert_response :success
  end

  test "should get new" do
    get new_an32324_url
    assert_response :success
  end

  test "should create an32324" do
    assert_difference("An32324.count") do
      post an32324s_url, params: { an32324: { apr: @an32324.apr, dec: @an32324.dec, email: @an32324.email, feb: @an32324.feb, ian: @an32324.ian, iul: @an32324.iul, iun: @an32324.iun, mai: @an32324.mai, mar: @an32324.mar, nov: @an32324.nov, nume: @an32324.nume, oct: @an32324.oct, pret: @an32324.pret, sep: @an32324.sep, telefon: @an32324.telefon } }
    end

    assert_redirected_to an32324_url(An32324.last)
  end

  test "should show an32324" do
    get an32324_url(@an32324)
    assert_response :success
  end

  test "should get edit" do
    get edit_an32324_url(@an32324)
    assert_response :success
  end

  test "should update an32324" do
    patch an32324_url(@an32324), params: { an32324: { apr: @an32324.apr, dec: @an32324.dec, email: @an32324.email, feb: @an32324.feb, ian: @an32324.ian, iul: @an32324.iul, iun: @an32324.iun, mai: @an32324.mai, mar: @an32324.mar, nov: @an32324.nov, nume: @an32324.nume, oct: @an32324.oct, pret: @an32324.pret, sep: @an32324.sep, telefon: @an32324.telefon } }
    assert_redirected_to an32324_url(@an32324)
  end

  test "should destroy an32324" do
    assert_difference("An32324.count", -1) do
      delete an32324_url(@an32324)
    end

    assert_redirected_to an32324s_url
  end
end
