module ProjectsHelper
	def nested_comments(comments)
		comments.map do |comment, sub_comments|
			render(comment) + content_tag(:div, nested_comments(sub_comments), :class => "nested_comments")
		end.join.html_safe
	end

	def show_more_projects(user_projects)
		html_output = ""
		@user_projects.each_with_index do |f, index|
			unless index >= 5 
				if f.project_name.length > 40
					f.project_name = f.project_name.slice(0, 40) + "..."
				end
				html_output = html_output + "<div class='right_sidebar_links'><a href=" + project_path(:id => f.id) + ">" + f.project_name + "</a></div><hr style='margin:2px'>"
			end
		end
		return html_output
	end
end
