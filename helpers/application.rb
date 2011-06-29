helpers do 
  def menu_item(text, description, path, css_class = 'blue')
    request_path = request.path_info
    css_selected_class = path == request_path ? ' selected' : ''
    css_class += css_selected_class + ' '
    "<a href=\"#{path}\" class=\"#{css_class}\">#{text}<br /><span>#{description}</span>#{yield if defined? yield}</a>"
  end  

  def list_thesis_menu
    html = "<ul>"
    Thesis.chapters.each do |chapter|
      html << "<li><a href='#{chapter.link}#sections' class='#{chapter.link == request.path ? "selected" : ""}'>#{chapter.formated_name}</a></li>"
    end
    html << "</ul>"
  end

  def thesis_menu_link
    "<a href='#'>Obsah</a>"
  end

  def previous_chapter_link(chapter)
    if chapter.previous
      "<a href='#{chapter.previous.link}#sections' class='left'>&laquo; #{chapter.previous.numbered_name}</a>"
    end
  end

  def next_chapter_link(chapter)
    if chapter.next
      "<a href='#{chapter.next.link}#sections' class='right'>#{chapter.next.numbered_name} &raquo;</a>"
    end    
  end  
end