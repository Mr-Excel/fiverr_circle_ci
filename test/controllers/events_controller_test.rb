# frozen_string_literal: true

require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  # Devise & Warden will help in signing in user while testing where we need authentication
  include Devise::Test::IntegrationHelpers
  include Warden::Test::Helpers

  # event object
  def event_object
    {
      name: 'Event 1',
      image: 'URL',
      start_date: '2023-01-01',
      end_date: '2022-10-02',
      max_participants: 12,
      street: 'Gulberg III',
      city: 'Lahore',
      state: 'Punjab',
      country: 'Pakistan',
      organizer_id: 1,
      latitude: 12.211213,
      longitude: 12.211213
    }
  end

  # this method will create a new event
  def creating_event
    Event.create(event_object)
  end

  # It will check index should return a value in index
  test 'should get index' do
    # creating event
    creating_event
    # hitting GET Request to "/events"
    get '/events'
    # checking if response is success or not if it is success than test will pass
    assert_response :success
    assert_not_nil assigns(:events)
  end

  test 'should create new event' do
    # signing in user
    user = FactoryBot.create(:user)
    login_as(user, scope: :user)
    # checking event count before posting the request
    before = Event.count
    # Hitting POST request
    post '/events',
         params: {
           event: event_object, headers: { 'Content-Type' => 'application/json' }
         }
    # checking counts after post
    after = Event.count
    # logging out user
    logout(:user)
    # checking count after post should be increased if it increase than test will pass
    assert_equal after, before + 1
  end

  test 'should return successful response' do
    creating_event
    # passing created event id as a parameter in url
    get "/events/#{creating_event.id}"
    # checking if event is exist and return is success it will pass test
    assert_response :success
    assert_not_nil assigns(:events)
  end

  test 'should not save article without name' do
    # there are certain validations in event model than name can not be empty checking that
    event = Event.new
    # if it return error than test is passed
    assert_not event.save
  end

  test 'should delete event' do
    creating_event
    before = Event.count
    delete "/events/#{Event.last.id}"
    after  = Event.count
    # checking if event count after delete is reduced or not if it reduced than test is passed
    assert_equal after, before - 1
  end
end
