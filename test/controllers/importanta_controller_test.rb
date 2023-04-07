require "test_helper"

class ImportantaControllerTest < ActionDispatch::IntegrationTest
  setup do
    @importantum = importanta(:one)
  end

  test "should get index" do
    get importanta_url
    assert_response :success
  end

  test "should get new" do
    get new_importantum_url
    assert_response :success
  end

  test "should create importantum" do
    assert_difference("Importantum.count") do
      post importanta_url, params: { importantum: { codimp: @importantum.codimp, descgrad: @importantum.descgrad, grad: @importantum.grad } }
    end

    assert_redirected_to importantum_url(Importantum.last)
  end

  test "should show importantum" do
    get importantum_url(@importantum)
    assert_response :success
  end

  test "should get edit" do
    get edit_importantum_url(@importantum)
    assert_response :success
  end

  test "should update importantum" do
    patch importantum_url(@importantum), params: { importantum: { codimp: @importantum.codimp, descgrad: @importantum.descgrad, grad: @importantum.grad } }
    assert_redirected_to importantum_url(@importantum)
  end

  test "should destroy importantum" do
    assert_difference("Importantum.count", -1) do
      delete importantum_url(@importantum)
    end

    assert_redirected_to importanta_url
  end
end
