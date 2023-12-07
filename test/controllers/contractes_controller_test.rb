require "test_helper"

class ContractesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contracte = contractes(:one)
  end

  test "should get index" do
    get contractes_url
    assert_response :success
  end

  test "should get new" do
    get new_contracte_url
    assert_response :success
  end

  test "should create contracte" do
    assert_difference("Contracte.count") do
      post contractes_url, params: { contracte: { contor: @contracte.contor, denumire: @contracte.denumire, email: @contracte.email, textcontract: @contracte.textcontract, tip: @contracte.tip, user_id: @contracte.user_id } }
    end

    assert_redirected_to contracte_url(Contracte.last)
  end

  test "should show contracte" do
    get contracte_url(@contracte)
    assert_response :success
  end

  test "should get edit" do
    get edit_contracte_url(@contracte)
    assert_response :success
  end

  test "should update contracte" do
    patch contracte_url(@contracte), params: { contracte: { contor: @contracte.contor, denumire: @contracte.denumire, email: @contracte.email, textcontract: @contracte.textcontract, tip: @contracte.tip, user_id: @contracte.user_id } }
    assert_redirected_to contracte_url(@contracte)
  end

  test "should destroy contracte" do
    assert_difference("Contracte.count", -1) do
      delete contracte_url(@contracte)
    end

    assert_redirected_to contractes_url
  end
end
