require 'test_helper'

class BeautystarsControllerTest < ActionController::TestCase
  setup do
    @beautystar = beautystars(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:beautystars)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create beautystar" do
    assert_difference('Beautystar.count') do
      post :create, beautystar: { fullname: @beautystar.fullname, introduction: @beautystar.introduction, job_title: @beautystar.job_title, view_count: @beautystar.view_count, vimeo_url: @beautystar.vimeo_url }
    end

    assert_redirected_to beautystar_path(assigns(:beautystar))
  end

  test "should show beautystar" do
    get :show, id: @beautystar
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @beautystar
    assert_response :success
  end

  test "should update beautystar" do
    put :update, id: @beautystar, beautystar: { fullname: @beautystar.fullname, introduction: @beautystar.introduction, job_title: @beautystar.job_title, view_count: @beautystar.view_count, vimeo_url: @beautystar.vimeo_url }
    assert_redirected_to beautystar_path(assigns(:beautystar))
  end

  test "should destroy beautystar" do
    assert_difference('Beautystar.count', -1) do
      delete :destroy, id: @beautystar
    end

    assert_redirected_to beautystars_path
  end
end
