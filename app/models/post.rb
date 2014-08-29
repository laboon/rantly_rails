class Post < ActiveRecord::Base
  attr_accessible :body, :title

  def initialize(body, title)
    @body = body
    @title = title
  end

  def title_display
    if @title.length > 100
      "#{@title[0..99]}"
    else
      "#{@title}"
    end
  end

  def checksum
    cs = 0
    @title.each_char { |c| cs = (cs + c.ord) % 256  }
    cs
  end

  def uppercase_title
    @title.upcase
  end

  def rot128(text)
    r = ""
    text.each_char { |c| r += ((c.ord + 128) % 256).chr }
    r
  end

end
