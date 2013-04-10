module PagesHelper
  def calculate_height_from_aspect(original_height, original_width, new_width) 
    new_height = (original_height.to_f / original_width.to_f) * new_width
    new_height.floor
  end

  def get_random_default(random_number)
    case random_number
      when 1
        return "shrooms/orange-shroom.jpg"
      when 2
        return "shrooms/blue-shroom.jpg"
      when 3
        return "shrooms/red-shroom.jpg"
      when 4
        return "shrooms/white-shroom.jpg"
      else
        return "shrooms/orange-shroom.jpg"
    end
  end
end
