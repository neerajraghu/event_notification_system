require 'test_helper'
require 'webmock/minitest'

class EventsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one) # We have a fixture set up for users (look for fixtures/users.yml)
    sign_in @user
  end

  # Test creating Event A
  test 'should create event A' do
    stub_request(:post, 'https://api.iterable.com/api/events')
      .with(
        body: { email: @user.email, event: 'event_a' }.to_json,  # Expect the request body to contain user email and event name
        headers: { 'Content-Type' => 'application/json', 'Api-Key' => 'YOUR_ITERABLE_API_KEY' }  # Expect specific headers in the request
      )
      .to_return(status: 200, body: '', headers: {})

    post '/events/create_event_a'  # Send a POST request to create Event A

    assert_redirected_to root_path
    assert_equal 'Event A created!', flash[:notice]  # Check that a success message is displayed
  end

  # Test creating Event B and sending notification
  test 'should create event B and send notification' do
    stub_request(:post, 'https://api.iterable.com/api/events')
      .with(
        body: { email: @user.email, event: 'event_b' }.to_json,  # Expect the request body to contain user email and event name
        headers: { 'Content-Type' => 'application/json', 'Api-Key' => 'YOUR_ITERABLE_API_KEY' }  # Expect specific headers in the request
      )
      .to_return(status: 200, body: '', headers: {})

    post '/events/create_event_b'  # Send a POST request to create Event B

    assert_redirected_to root_path
    assert_equal 'Event B created!', flash[:notice]  # Check that a success message is displayed
  end

  # Test handling error when creating Event A
  test 'should handle error when creating event A' do
    stub_request(:post, 'https://api.iterable.com/api/events')
      .to_return(status: 500, body: 'Internal Server Error', headers: {})  # Return a server error response

    post '/events/create_event_a'  # Send a POST request to create Event A

    assert_redirected_to root_path
    assert_equal 'Failed to create event. Please try again later.', flash[:alert]  # Check that an error message is displayed
  end

  # Test handling error when creating Event B
  test 'should handle error when creating event B' do
    stub_request(:post, 'https://api.iterable.com/api/events')
      .to_return(status: 500, body: 'Internal Server Error', headers: {})  # Return a server error response

    post '/events/create_event_b'  # Send a POST request to create Event B

    assert_redirected_to root_path
    assert_equal 'Failed to send notification. Please try again later.', flash[:alert]  # Check that an error message is displayed
  end
end
