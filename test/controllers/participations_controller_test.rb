# frozen_string_literal: true

require 'test_helper'

class ParticipationsControllerTest < ActionDispatch::IntegrationTest
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

  test 'should create new participation' do
    user = FactoryBot.create(:user)
    login_as(user, scope: :user)
    before = Participation.count
    # creating new event with organizer id
    new_event = {
      name: 'Event 1',
      image: 'URL',
      start_date: '2023-01-01',
      end_date: '2022-10-02',
      max_participants: 12,
      street: 'Gulberg III',
      city: 'Lahore',
      state: 'Punjab',
      country: 'Pakistan',
      organizer_id: user.id,
      latitude: 12.211213,
      longitude: 12.211213
    }
    event = Event.create(new_event)
    # checking participants with created events
    post "/events/#{event.id}/participations", params: {
      event: { event_id: event.id, user_id: user.id }, headers: { 'Content-Type' => 'application/json' }
    }
    after = Participation.count
    logout(:user)
    assert_equal after, before + 1
  end

  test 'should update participation data' do
    # this test will conclude that participation ban and un-ban is working fine
    user = FactoryBot.create(:user)
    login_as(user, scope: :user)
    new_event = {
      name: 'Event 1',
      image: 'URL',
      start_date: '2023-01-01',
      end_date: '2022-10-02',
      max_participants: 12,
      street: 'Gulberg III',
      city: 'Lahore',
      state: 'Punjab',
      country: 'Pakistan',
      organizer_id: user.id,
      latitude: 12.211213,
      longitude: 12.211213
    }
    event = Event.create(new_event)
    Participation.create(event_id: event.id, user_id: user.id)
    before = Participation.where(is_banned: true).count
    # un-banning a user if its banned
    put "/participations/#{event.id}"
    after = Participation.where(is_banned: true).count
    logout(:user)
    assert_equal after, before + 1
  end

  test 'should delete participations' do
    user = FactoryBot.create(:user)
    login_as(user, scope: :user)
    new_event = {
      name: 'Event 1',
      image: 'URL',
      start_date: '2023-01-01',
      end_date: '2022-10-02',
      max_participants: 12,
      street: 'Gulberg III',
      city: 'Lahore',
      state: 'Punjab',
      country: 'Pakistan',
      organizer_id: user.id,
      latitude: 12.211213,
      longitude: 12.211213
    }
    event = Event.create(new_event)
    participtation = Participation.create(event_id: event.id, user_id: user.id)
    before = Participation.count
    delete "/participations/#{participtation.id}"
    after  = Participation.count
    logout(:user)
    assert_equal after, before - 1
  end
end
