# frozen_string_literal: true

require 'test_helper'

class EventTest < ActiveSupport::TestCase
  def test_hash(organizer_id = 1)
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
      organizer_id:,
      latitude: 12.211213,
      longitude: 12.211213
    }
  end

  test 'should have participations' do
    # this method will check associations is working or not
    # creating two organizers
    organizer1 = User.create(email: 'user@example.com', password: 'password', is_organizer: true)
    organizer2 = User.create(email: 'user2@example.com', password: 'password', is_organizer: true)
    # creating a event
    event = Event.create(test_hash(organizer1.id))
    # trying to store two participants in the event
    participant1 = Participation.create(user_id: organizer1.id, event_id: event.id)
    participant2 = Participation.create(user_id: organizer2.id, event_id: event.id)
    # it should return both participants after join
    assert_equal [participant1, participant2], Participation.joins(:event)
  end

  test 'should have one organizer' do
    # checking organizer relationship
    # every event should have one organizer
    organizer = User.create(email: 'user@example.com', password: 'password', is_organizer: true)
    event = Event.new(test_hash(organizer.id))
    assert event.save
    assert_equal organizer, event.organizer
  end
end
