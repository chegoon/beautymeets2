require 'test_helper'

class ChannelLogDetailsControllerTest < ActionController::TestCase
  setup do
    @channel_log_detail = channel_log_details(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:channel_log_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create channel_log_detail" do
    assert_difference('ChannelLogDetail.count') do
      post :create, channel_log_detail: { collected_at: @channel_log_detail.collected_at, comment_count: @channel_log_detail.comment_count, like_count: @channel_log_detail.like_count, share_count: @channel_log_detail.share_count, view_count: @channel_log_detail.view_count }
    end

    assert_redirected_to channel_log_detail_path(assigns(:channel_log_detail))
  end

  test "should show channel_log_detail" do
    get :show, id: @channel_log_detail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @channel_log_detail
    assert_response :success
  end

  test "should update channel_log_detail" do
    put :update, id: @channel_log_detail, channel_log_detail: { collected_at: @channel_log_detail.collected_at, comment_count: @channel_log_detail.comment_count, like_count: @channel_log_detail.like_count, share_count: @channel_log_detail.share_count, view_count: @channel_log_detail.view_count }
    assert_redirected_to channel_log_detail_path(assigns(:channel_log_detail))
  end

  test "should destroy channel_log_detail" do
    assert_difference('ChannelLogDetail.count', -1) do
      delete :destroy, id: @channel_log_detail
    end

    assert_redirected_to channel_log_details_path
  end
end
