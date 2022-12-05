# frozen_string_literal: true

require 'test_helper'
class RequestsTest < ActiveSupport::TestCase
    test 'requests sin params' do
        request =Request.new
        assert !request.save
    end
    
    test 'create requests sin user' do
        request = Request.new(placement: 1,height: 1, width: 1, color: "blue", image_url: "image_url.png")
        assert !request.save
    end
end