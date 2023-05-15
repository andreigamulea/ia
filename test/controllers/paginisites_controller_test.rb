require "test_helper"

class PaginisitesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @paginisite = paginisites(:one)
  end

  test "should get index" do
    get paginisites_url
    assert_response :success
  end

  test "should get new" do
    get new_paginisite_url
    assert_response :success
  end

  test "should create paginisite" do
    assert_difference("Paginisite.count") do
      post paginisites_url, params: { paginisite: { nume: @paginisite.nume } }
    end

    assert_redirected_to paginisite_url(Paginisite.last)
  end

  test "should show paginisite" do
    get paginisite_url(@paginisite)
    assert_response :success
  end

  test "should get edit" do
    get edit_paginisite_url(@paginisite)
    assert_response :success
  end

  test "should update paginisite" do
    patch paginisite_url(@paginisite), params: { paginisite: { nume: @paginisite.nume } }
    assert_redirected_to paginisite_url(@paginisite)
  end

  test "should destroy paginisite" do
    assert_difference("Paginisite.count", -1) do
      delete paginisite_url(@paginisite)
    end

    assert_redirected_to paginisites_url
  end
end
