require 'test_helper'

class ChannelLogsControllerTest < ActionController::TestCase
  setup do
    @channel_log = channel_logs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:channel_logs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create channel_log" do
    assert_difference('ChannelLog.count') do
      post :create, channel_log: { channel_loggable_id: @channel_log.channel_loggable_id, channel_loggable_type: @channel_log.channel_loggable_type, uploaded_at: @channel_log.uploaded_at, url: @channel_log.url }
    end

    assert_redirected_to channel_log_path(assigns(:channel_log))
  end

  test "should show channel_log" do
    get :show, id: @channel_log
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @channel_log
    assert_response :success
  end

  test "should update channel_log" do
    put :update, id: @channel_log, channel_log: { channel_loggable_id: @channel_log.channel_loggable_id, channel_loggable_type: @channel_log.channel_loggable_type, uploaded_at: @channel_log.uploaded_at, url: @channel_log.url }
    assert_redirected_to channel_log_path(assigns(:channel_log))
  end

  test "should destroy channel_log" do
    assert_difference('ChannelLog.count', -1) do
      delete :destroy, id: @channel_log
    end

    assert_redirected_to channel_logs_path
  end
end
