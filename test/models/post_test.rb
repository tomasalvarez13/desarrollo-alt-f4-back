# frozen_string_literal: true

require 'test_helper'
class PostsTest < ActiveSupport::TestCase
    test 'post sin params' do
        post = Post.new
        assert !post.save
    end
    
    test 'create post' do
        post = Post.new(price: 10, placement: 1, height: 1.0, width: 1.0, image_url: "www.url.org")
        assert !post.save
    end
end