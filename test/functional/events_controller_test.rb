require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  setup do
    @event = events(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:events)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create event" do
    assert_difference('Event.count') do
      post :create, event: { desc: @event.desc, finish_on: @event.finish_on, released_at: @event.released_at, result_released_on: @event.result_released_on, start_from: @event.start_from, title: @event.title, view_count: @event.view_count }
    end

    assert_redirected_to event_path(assigns(:event))
  end

  test "should show event" do
    get :show, id: @event
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @event
    assert_response :success
  end

  test "should update event" do
    put :update, id: @event, event: { desc: @event.desc, finish_on: @event.finish_on, released_at: @event.released_at, result_released_on: @event.result_released_on, start_from: @event.start_from, title: @event.title, view_count: @event.view_count }
    assert_redirected_to event_path(assigns(:event))
  end

  test "should destroy event" do
    assert_difference('Event.count', -1) do
      delete :destroy, id: @event
    end

    assert_redirected_to events_path
  end
end
