require 'httparty'

class EventsController < ApplicationController
  before_action :authenticate_user!  # Ensure that the user is authenticated before accessing any actions

  # Create Event A and redirect to the root page
  def create_event_a
    create_iterable_event('event_a')  # Call the method to create an event named 'event_a' on Iterable.com

    flash[:notice] = 'Event A created!'
    redirect_to root_path
  end

  # Create Event B, send a notification if the user exists, and redirect to the root page
  def create_event_b
    if current_user.nil?
      flash[:alert] = 'No user found for Event B.'  # Display an alert message if no user is found
    else
      create_iterable_event('event_b')  # Call the method to create an event named 'event_b' on Iterable.com
      send_event_b_notification(current_user.email)  # Send a notification for Event B if the user exists
    end

    flash[:notice] = 'Event B created!'
    redirect_to root_path
  end

  private

  # Create an event on Iterable.com
  def create_iterable_event(event_name)
    email = current_user.email  # Get the email of the current user
    response = HTTParty.post(
      'https://api.iterable.com/api/events',
      body: { email: email, event: event_name }.to_json,
      headers: { 'Content-Type' => 'application/json', 'Api-Key' => 'YOUR_ITERABLE_API_KEY' }
    )

    handle_response(response, event_name, email)  # Handle the response from the Iterable API
  end

  # Send an email notification for Event B
  def send_event_b_notification(email)
    if email.nil?
      Rails.logger.error('No user found for Event B.')  # Log an error if no user is found for Event B
    else
      response = HTTParty.post(
        'https://api.iterable.com/api/events',
        body: { email: email, event: 'event_b' }.to_json,
        headers: { 'Content-Type' => 'application/json', 'Api-Key' => 'YOUR_ITERABLE_API_KEY' }
      )

      handle_notification_response(response, email)  # Handle the response from the Iterable API
    end
  end

  # Handle response from Iterable API for event creation
  def handle_response(response, event_name, email)
    if response.success?
      Rails.logger.info("Event #{event_name} created successfully for user #{email} on Iterable.com.")  # Log a success message if the event is created successfully
    else
      Rails.logger.error("Failed to create event #{event_name} for user #{email} on Iterable.com: #{response.body}")
      flash[:alert] = 'Failed to create event. Please try again later.'
    end
  end

  # Handle response from Iterable API for notification
  def handle_notification_response(response, email)
    if response.success?
      Rails.logger.info("Notification sent successfully for user #{email}.")  # Log a success message if the notification is sent successfully
    else
      Rails.logger.error("Failed to send notification for user #{email}: #{response.body}")
      flash[:alert] = 'Failed to send notification. Please try again later.'
    end
  end
end
