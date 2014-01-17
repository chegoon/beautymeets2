require 'test_helper'

class BeautyclassesControllerTest < ActionController::TestCase
  setup do
    @beautyclass = beautyclasses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:beautyclasses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create beautyclass" do
    assert_difference('Beautyclass.count') do
      post :create, beautyclass: { capacity: @beautyclass.capacity, description: @beautyclass.description, published: @beautyclass.published, soldout: @beautyclass.soldout, title: @beautyclass.title, view_count: @beautyclass.view_count }
    end

    assert_redirected_to beautyclass_path(assigns(:beautyclass))
  end

  test "should show beautyclass" do
    get :show, id: @beautyclass
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @beautyclass
    assert_response :success
  end

  test "should update beautyclass" do
    put :update, id: @beautyclass, beautyclass: { capacity: @beautyclass.capacity, description: @beautyclass.description, published: @beautyclass.published, soldout: @beautyclass.soldout, title: @beautyclass.title, view_count: @beautyclass.view_count }
    assert_redirected_to beautyclass_path(assigns(:beautyclass))
  end

  test "should destroy beautyclass" do
    assert_difference('Beautyclass.count', -1) do
      delete :destroy, id: @beautyclass
    end

    assert_redirected_to beautyclasses_path
  end
end
