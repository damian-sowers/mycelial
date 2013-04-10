module ProjectsHelper
  def nested_comments(comments)
    comments.map do |comment, sub_comments|
      render(comment) + content_tag(:div, nested_comments(sub_comments), :class => "nested_comments")
    end.join.html_safe
  end

  def get_more_projects(user_projects, current_project_id)
    html_output = Hash.new
    @user_projects.each_with_index do |f, index|
      unless index >= 5 or f.id == current_project_id
        if f.project_name.length > 40
          f.project_name = f.project_name.slice(0, 40) + "..."
        end
        html_output[f.id] = f.project_name
      end
    end
    return html_output
  end

  def show_tag_language(project)
    case project.project_type
      when 1
        return "Main Languages and Technologies"
      else
        return "Tags"
    end 
  end
end
