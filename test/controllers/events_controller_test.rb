require 'test_helper'
require 'webmock/minitest'

class EventsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    # We have a fixture set up for users (look for fixtures/users.yml)
    @user = users(:one)
    sign_in @user
  end

  # Test creating Event A
  test 'should create event A' do
    # Stub the request to Iterable API for creating event A
    stub_request(:post, 'https://api.iterable.com/api/events')
      .with(
        body: { email: @user.email, event: 'event_a' }.to_json,
        headers: { 'Content-Type' => 'application/json', 'Api-Key' => 'YOUR_ITERABLE_API_KEY' }
      )
      .to_return(status: 200, body: '', headers: {})

    # Send a POST request to create Event A
    post '/events/create_event_a'

    # Check that the user is redirected to the root path and a success message is displayed
    assert_redirected_to root_path
    assert_equal 'Event A created!', flash[:notice]
  end

  # Test creating Event B and sending notification
  test 'should create event B and send notification' do
    # Stub the request to Iterable API for creating event B
    stub_request(:post, 'https://api.iterable.com/api/events')
      .with(
        body: { email: @user.email, event: 'event_b' }.to_json,
        headers: { 'Content-Type' => 'application/json', 'Api-Key' => 'YOUR_ITERABLE_API_KEY' }
      )
      .to_return(status: 200, body: '', headers: {})

    # Send a POST request to create Event B
    post '/events/create_event_b'

    # Check that the user is redirected to the root path, a success message for Event B creation is displayed
    assert_redirected_to root_path
    assert_equal 'Event B created!', flash[:notice]
  end

  # Test handling error when creating Event A
  test 'should handle error when creating event A' do
    # Stub the request to Iterable API for creating event A with a server error response
    stub_request(:post, 'https://api.iterable.com/api/events')
      .to_return(status: 500, body: 'Internal Server Error', headers: {})

    # Send a POST request to create Event A
    post '/events/create_event_a'

    # Check that the user is redirected to the root path and an error message is displayed
    assert_redirected_to root_path
    assert_equal 'Failed to create event. Please try again later.', flash[:alert]
  end

  # Test handling error when creating Event B
  test 'should handle error when creating event B' do
    # Stub the request to Iterable API for creating event B with a server error response
    stub_request(:post, 'https://api.iterable.com/api/events')
      .to_return(status: 500, body: 'Internal Server Error', headers: {})

    # Send a POST request to create Event B
    post '/events/create_event_b'

    # Check that the user is redirected to the root path and an error message is displayed
    assert_redirected_to root_path
    assert_equal 'Failed to send notification. Please try again later.', flash[:alert]
  end
end
