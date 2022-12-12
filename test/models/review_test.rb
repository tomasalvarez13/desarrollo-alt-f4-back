# frozen_string_literal: true

require 'test_helper'
class ReviewsTest < ActiveSupport::TestCase
    test 'reviews sin params' do
        review = Review.new
        assert !review.save
    end
    
    test 'create reviews sin user' do
        review = Review.new(score: 5, coment: "de pana")
        assert !review.save
    end
end