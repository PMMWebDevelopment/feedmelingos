require 'test_helper'

class SourcetypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sourcetype = sourcetypes(:one)
  end

  test "should get index" do
    get sourcetypes_url
    assert_response :success
  end

  test "should get new" do
    get new_sourcetype_url
    assert_response :success
  end

  test "should create sourcetype" do
    assert_difference('Sourcetype.count') do
      post sourcetypes_url, params: { sourcetype: { sourcetype: @sourcetype.sourcetype } }
    end

    assert_redirected_to sourcetype_url(Sourcetype.last)
  end

  test "should show sourcetype" do
    get sourcetype_url(@sourcetype)
    assert_response :success
  end

  test "should get edit" do
    get edit_sourcetype_url(@sourcetype)
    assert_response :success
  end

  test "should update sourcetype" do
    patch sourcetype_url(@sourcetype), params: { sourcetype: { sourcetype: @sourcetype.sourcetype } }
    assert_redirected_to sourcetype_url(@sourcetype)
  end

  test "should destroy sourcetype" do
    assert_difference('Sourcetype.count', -1) do
      delete sourcetype_url(@sourcetype)
    end

    assert_redirected_to sourcetypes_url
  end
end
