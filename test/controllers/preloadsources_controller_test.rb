require 'test_helper'

class PreloadsourcesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @preloadsource = preloadsources(:one)
  end

  test "should get index" do
    get preloadsources_url
    assert_response :success
  end

  test "should get new" do
    get new_preloadsource_url
    assert_response :success
  end

  test "should create preloadsource" do
    assert_difference('Preloadsource.count') do
      post preloadsources_url, params: { preloadsource: { language_id: @preloadsource.language_id, preloadsourcename: @preloadsource.preloadsourcename, preloadsourceurl: @preloadsource.preloadsourceurl, sourcetype_id: @preloadsource.sourcetype_id } }
    end

    assert_redirected_to preloadsource_url(Preloadsource.last)
  end

  test "should show preloadsource" do
    get preloadsource_url(@preloadsource)
    assert_response :success
  end

  test "should get edit" do
    get edit_preloadsource_url(@preloadsource)
    assert_response :success
  end

  test "should update preloadsource" do
    patch preloadsource_url(@preloadsource), params: { preloadsource: { language_id: @preloadsource.language_id, preloadsourcename: @preloadsource.preloadsourcename, preloadsourceurl: @preloadsource.preloadsourceurl, sourcetype_id: @preloadsource.sourcetype_id } }
    assert_redirected_to preloadsource_url(@preloadsource)
  end

  test "should destroy preloadsource" do
    assert_difference('Preloadsource.count', -1) do
      delete preloadsource_url(@preloadsource)
    end

    assert_redirected_to preloadsources_url
  end
end
