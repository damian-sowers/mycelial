module ProjectsHelper
	def nested_comments(comments)
		comments.map do |comment, sub_comments|
			render(comment) + content_tag(:div, nested_comments(sub_comments), :class => "nested_comments")
		end.join.html_safe
	end

	def show_more_projects(user_projects, current_project_id)
		html_output = ""
		@user_projects.each_with_index do |f, index|
			unless index >= 5 or f.id == current_project_id
				if f.project_name.length > 40
					f.project_name = f.project_name.slice(0, 40) + "..."
				end
				html_output = html_output + "<div class='right_sidebar_links'><a href=" + project_path(:id => f.id) + ">" + h(f.project_name) + "</a></div><hr style='margin:2px'>"
			end
		end
		return html_output
	end

	def show_tag_language(project)
		case project.project_type
			when 1
				return "Main Languages and Technologies"
			when 2
				return "Blog Tags"
			when 3
				return "Tags"
			else
				return "Tags"
		end 
	end
end
