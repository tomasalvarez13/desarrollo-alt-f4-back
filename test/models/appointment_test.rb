# frozen_string_literal: true

require 'test_helper'
class AppointmentTest < ActiveSupport::TestCase
  test 'appointment sin params' do
    appointment = Appointment.new
    assert !appointment.save
  end

  test 'create post sin user' do
    appointment = Appointment.new(descrption: 'long description', start_time: '2022-02-03T12:00:00+00:00',
                                  end_time: '2022-02-03T12:01:00+00:00')
    assert !appointment.save
  end
end
