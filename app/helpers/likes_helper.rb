module LikesHelper
  def get_random_thumb(random_number)
    case random_number
      when 1
        return "shrooms/orange-shroom-small.jpg"
      when 2
        return "shrooms/blue-shroom-small.jpg"
      when 3
        return "shrooms/red-shroom-small.jpg"
      when 4
        return "shrooms/white-shroom-small.jpg"
      else
        return "shrooms/orange-shroom-small.jpg"
    end
  end
end
