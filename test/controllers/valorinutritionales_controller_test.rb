require "test_helper"

class ValorinutritionalesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @valorinutritionale = valorinutritionales(:one)
  end

  test "should get index" do
    get valorinutritionales_url
    assert_response :success
  end

  test "should get new" do
    get new_valorinutritionale_url
    assert_response :success
  end

  test "should create valorinutritionale" do
    assert_difference("Valorinutritionale.count") do
      post valorinutritionales_url, params: { valorinutritionale: { aliment: @valorinutritionale.aliment, calorii: @valorinutritionale.calorii, carbohidrati: @valorinutritionale.carbohidrati, cod: @valorinutritionale.cod, fibre: @valorinutritionale.fibre, lipide: @valorinutritionale.lipide, proteine: @valorinutritionale.proteine } }
    end

    assert_redirected_to valorinutritionale_url(Valorinutritionale.last)
  end

  test "should show valorinutritionale" do
    get valorinutritionale_url(@valorinutritionale)
    assert_response :success
  end

  test "should get edit" do
    get edit_valorinutritionale_url(@valorinutritionale)
    assert_response :success
  end

  test "should update valorinutritionale" do
    patch valorinutritionale_url(@valorinutritionale), params: { valorinutritionale: { aliment: @valorinutritionale.aliment, calorii: @valorinutritionale.calorii, carbohidrati: @valorinutritionale.carbohidrati, cod: @valorinutritionale.cod, fibre: @valorinutritionale.fibre, lipide: @valorinutritionale.lipide, proteine: @valorinutritionale.proteine } }
    assert_redirected_to valorinutritionale_url(@valorinutritionale)
  end

  test "should destroy valorinutritionale" do
    assert_difference("Valorinutritionale.count", -1) do
      delete valorinutritionale_url(@valorinutritionale)
    end

    assert_redirected_to valorinutritionales_url
  end
end
