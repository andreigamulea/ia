require "test_helper"

class SrotaControllerTest < ActionDispatch::IntegrationTest
  setup do
    @srotum = srota(:one)
  end

  test "should get index" do
    get srota_url
    assert_response :success
  end

  test "should get new" do
    get new_srotum_url
    assert_response :success
  end

  test "should create srotum" do
    assert_difference("Srotum.count") do
      post srota_url, params: { srotum: { codsr: @srotum.codsr, codsrota: @srotum.codsrota, explicatie: @srotum.explicatie, functii: @srotum.functii, numescurt: @srotum.numescurt, numesrota: @srotum.numesrota, observatie: @srotum.observatie, origine: @srotum.origine, parti: @srotum.parti } }
    end

    assert_redirected_to srotum_url(Srotum.last)
  end

  test "should show srotum" do
    get srotum_url(@srotum)
    assert_response :success
  end

  test "should get edit" do
    get edit_srotum_url(@srotum)
    assert_response :success
  end

  test "should update srotum" do
    patch srotum_url(@srotum), params: { srotum: { codsr: @srotum.codsr, codsrota: @srotum.codsrota, explicatie: @srotum.explicatie, functii: @srotum.functii, numescurt: @srotum.numescurt, numesrota: @srotum.numesrota, observatie: @srotum.observatie, origine: @srotum.origine, parti: @srotum.parti } }
    assert_redirected_to srotum_url(@srotum)
  end

  test "should destroy srotum" do
    assert_difference("Srotum.count", -1) do
      delete srotum_url(@srotum)
    end

    assert_redirected_to srota_url
  end
end
