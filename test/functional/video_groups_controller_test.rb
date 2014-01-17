require 'test_helper'

class VideoGroupsControllerTest < ActionController::TestCase
  setup do
    @video_group = video_groups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:video_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create video_group" do
    assert_difference('VideoGroup.count') do
      post :create, video_group: { home_url: @video_group.home_url, image: @video_group.image, name: @video_group.name, thumb_url: @video_group.thumb_url, view_count: @video_group.view_count, youtube_id: @video_group.youtube_id }
    end

    assert_redirected_to video_group_path(assigns(:video_group))
  end

  test "should show video_group" do
    get :show, id: @video_group
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @video_group
    assert_response :success
  end

  test "should update video_group" do
    put :update, id: @video_group, video_group: { home_url: @video_group.home_url, image: @video_group.image, name: @video_group.name, thumb_url: @video_group.thumb_url, view_count: @video_group.view_count, youtube_id: @video_group.youtube_id }
    assert_redirected_to video_group_path(assigns(:video_group))
  end

  test "should destroy video_group" do
    assert_difference('VideoGroup.count', -1) do
      delete :destroy, id: @video_group
    end

    assert_redirected_to video_groups_path
  end
end
