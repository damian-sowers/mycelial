module PagesHelper
	def calculate_height_from_aspect(original_height, original_width, new_width) 
		new_height = (original_height.to_f / original_width.to_f) * new_width
		new_height.floor
	end
end
