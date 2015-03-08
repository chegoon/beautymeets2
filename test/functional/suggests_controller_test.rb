require 'test_helper'

class SuggestsControllerTest < ActionController::TestCase
  setup do
    @suggest = suggests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:suggests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create suggest" do
    assert_difference('Suggest.count') do
      post :create, suggest: { description: @suggest.description, title: @suggest.title }
    end

    assert_redirected_to suggest_path(assigns(:suggest))
  end

  test "should show suggest" do
    get :show, id: @suggest
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @suggest
    assert_response :success
  end

  test "should update suggest" do
    put :update, id: @suggest, suggest: { description: @suggest.description, title: @suggest.title }
    assert_redirected_to suggest_path(assigns(:suggest))
  end

  test "should destroy suggest" do
    assert_difference('Suggest.count', -1) do
      delete :destroy, id: @suggest
    end

    assert_redirected_to suggests_path
  end
end
