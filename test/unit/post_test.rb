require 'test_helper'
require 'rantly/testunit_extensions'

class PostTest < ActiveSupport::TestCase


  test "test that Rantly works" do
    Rantly(500) {integer}.each { |x| assert_equal x, x }
  end

  test "Title display handles alpha strings" do

    Rantly(10) { string(:alpha) }.each do |s|
      p = Post.new(s, s)
      assert_equal p.title_display, "#{s}"
    end

  end

  test "Title display handles control strings" do
    Rantly(10) { [string(:cntrl), string(:cntrl)] }.each do |s|
      p = Post.new(s, s)
      assert_equal p.title_display, "#{s}"
    end
  end

  test "Titles are never > 100 chars, no matter length of input" do
    # The following is a different way of expressing a Rantly test.
    # Rantly(10) { sized(rand(1..1000)) { string }}.each do |s|
    #   p = Post.new(s, s)
    #   assert p.title_display.length <= 100
    # end
    property_of {
      s = sized(rand(1..1000)) { string }
    }.check { |s|
      p = Post.new(s, s)
      assert p.title_display.length <= 100
    }
  end



end
