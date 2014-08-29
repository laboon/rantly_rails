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

  test "checksums are always between 0 and 255" do
    property_of {
      s = sized(rand(1..1000)) { string }
    }.check { |s|
      p = Post.new(s, s)
      assert (p.checksum >= 0 && p.checksum <= 255)
    }
  end

  test "checksums for the same string should always be the same, even on different posts" do
    property_of {
      s = sized(rand(1..1000)) { string }
    }.check { |s|
      a = Post.new(s, s)
      b = Post.new(s, s)
      assert_equal a.checksum, b.checksum
    }
  end

  test "uppercase_title should never return a lowercase letter" do

    property_of {
      s = sized(rand(1..1000)) { string(:alpha) }
    }.check { |s|
      p = Post.new(s, s)
      # puts p.uppercase_title
      assert !(p.uppercase_title.match(/.*[[:lower:]]+.*/))
    }

  end

  test "uppercase_title should be idempotent" do
    property_of {
      s = sized(rand(1..1000)) { string(:alpha) }
    }.check { |s|
      p1 = Post.new(s, s)
      p2 = Post.new(p1.uppercase_title, p1.uppercase_title)
      assert_equal p1.uppercase_title, p2.uppercase_title
    }

  end

  test "rot128 should always return same length string" do
    property_of {
      s = sized(rand(1..1000)) { string }
    }.check { |s|
      p1 = Post.new(s, s)
      t = p1.title_display
      assert_equal t.length, p1.rot128(t).length
    }

  end

  test "rot128 called once should never be the same value as original" do
    property_of {
      s = sized(rand(1..1000)) { string }
    }.check { |s|
      p1 = Post.new(s, s)
      t = p1.title_display
      assert_not_equal t,  p1.rot128(t)
    }

  end


  test "rot128 called twice should return original value" do
    property_of {
      s = sized(rand(1..1000)) { string }
    }.check { |s|
      p1 = Post.new(s, s)
      t = p1.title_display
      assert_equal t, p1.rot128( p1.rot128(t))
    }

  end


end
