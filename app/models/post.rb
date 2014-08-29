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

end
